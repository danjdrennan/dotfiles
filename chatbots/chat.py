from typing import NamedTuple
import argparse
import os
import anthropic
import openai
import dotenv

Message = dict[str, str]


class TokenUse(NamedTuple):
    input_tokens: int
    output_tokens: int
    total_tokens: int

    @classmethod
    def from_openai(cls, usage: openai.types.CompletionUsage) -> "TokenUse":
        input_tokens = usage.prompt_tokens
        output_tokens = usage.completion_tokens
        total_tokens = usage.total_tokens
        return cls(input_tokens, output_tokens, total_tokens)

    @classmethod
    def from_anthropic(cls, usage: anthropic.types.Usage) -> "TokenUse":
        input_tokens = usage.input_tokens
        output_tokens = usage.output_tokens
        total_tokens = input_tokens + output_tokens
        return cls(input_tokens, output_tokens, total_tokens)


def text_writer(fname: str, messages: list[Message]):
    with open(fname, "w") as f:
        f.write(f"# {fname.split('.')[0]}\n\n")
        f.write("## Question\n")
        f.write(messages[0]["content"])
        for message in messages[1:]:
            role = message["role"]
            if role == "user":
                f.write("\n\n## Question\n")
            else:
                f.write("\n\n---\n\n")
            content = message["content"]
            f.write(content)


class ModelInterface:
    api_key: str
    model: str
    system_prompt: str | Message | Message
    max_tokens: int
    temperature: float
    messages: list[Message]
    usage: TokenUse

    def get_usage(self) -> TokenUse:
        if not self.usage:
            return TokenUse(0, 0, 0)
        else:
            return self.usage

    def query(self, query) -> tuple[str, TokenUse]:
        raise NotImplementedError("Must be defined by subtypes.")

    def save(self, fname: str | None = None):
        """Write chat messages out."""
        raise NotImplementedError("Must be defined by subtypes.")

    def new_session(self):
        """Creates a new session by dropping all messages."""
        raise NotImplementedError("Must be defined by subtypes.")

    def load_file(self, fname: str):
        try:
            with open(fname, "r") as f:
                text = f.read()
                content = f"<file_name>{fname}</file_name>\n<|im_start>{text}<|im_end|>"
                self.messages.append({"role": "user", "content": content})
        except FileNotFoundError as e:
            print(f"File not found {e}")


class OpenAIModel(ModelInterface):
    def __init__(
        self,
        *,
        api_key: str,
        model: str,
        system_prompt: str,
        max_tokens: int,
        temperature: float,
    ):
        self.api_key = api_key
        self.model = model
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.client = openai.OpenAI(api_key=api_key)

        system: Message = {
            "role": "system",
            "content": system_prompt,
        }
        self.system_prompt = system
        self.messages: list[Message] = [system]

    def query(self, query: str) -> tuple[str, TokenUse]:
        new_content = ""
        while self.messages[-1]["role"] == "user":
            user_content: Message = self.messages.pop()
            new_content += "\n" + user_content["content"]
            if len(self.messages) < 2:
                break
        new_content += "\n" + query
        new_query: Message = {"role": "user", "content": new_content}
        self.messages.append(new_query)

        # LSP catches a reportCallIssue here, but this interface works fine in
        # a REPL environment and matches the typing in docs (version 1.40.6)
        response = self.client.chat.completions.create(  # pyright: ignore
            model=self.model,
            temperature=self.temperature,
            max_tokens=self.max_tokens,
            messages=self.messages,  # pyright: ignore
        )

        message: str = response.choices[0].message.content
        token_use = TokenUse.from_openai(response.usage)  # pyright: ignore
        new_response: Message = {"role": "assistant", "content": message}
        self.messages.append(new_response)

        return message, token_use

    def save(self, fname: str | None = None):
        """Write chat messages out."""
        if not fname:
            fname = f"{self.model}-messages{len(self.messages)}.md"

        text_writer(fname, self.messages[1:])

        return


class AnthropicModel(ModelInterface):
    def __init__(
        self,
        *,
        api_key: str,
        model: str,
        system_prompt: str,
        max_tokens: int,
        temperature: float,
    ):
        self.api_key = api_key
        self.model = model
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.client = anthropic.Anthropic(api_key=api_key)

        self.system_prompt = system_prompt
        assert isinstance(self.system_prompt, str)
        self.messages: list[Message] = []

    def query(self, query: str) -> tuple[str, TokenUse]:
        # Need to have user-assistant-user-assistant sequences for all queries.
        # That implies we need to get all user-user-user sequences and squash
        # them into a single user message.
        new_content = ""
        while len(self.messages) >= 1 and self.messages[-1]["role"] == "user":
            user_content: Message = self.messages.pop()
            new_content += "\n" + user_content["content"]
            if len(self.messages) == 0:
                break
        new_content += "\n" + query
        new_query: Message = {"role": "user", "content": new_content}
        self.messages.append(new_query)

        # LSP doesn't understand this interface
        response = self.client.messages.create(  # pyright: ignore
            model=self.model,
            temperature=self.temperature,
            system=self.system_prompt,  # pyright: ignore
            max_tokens=self.max_tokens,
            messages=self.messages,  # pyright: ignore
        )

        message: str = response.content[0].text  # pyright: ignore
        token_use = TokenUse.from_anthropic(response.usage)
        new_response: Message = {"role": "assistant", "content": message}
        self.messages.append(new_response)

        return message, token_use

    def save(self, fname: str | None = None):
        """Write chat messages out."""
        if not fname:
            fname = f"{self.model}-messages{len(self.messages)}.md"

        text_writer(fname, self.messages)

        return

    def new_session(self):
        """Creates a new session by dropping all messages."""
        self.messages = []


def event_loop(args: argparse.Namespace):
    """Main event loop."""
    dotenv.load_dotenv()

    system_prompt = os.getenv("PROMPT") or "You are a programming assistant."
    temperature = args.temperature
    max_tokens = args.max_tokens

    if args.use_anthropic:
        model = os.getenv("ANTHROPIC_MODEL") or "claude-3.5-sonnet-20240620"
        api_key = os.getenv("ANTHROPIC_API_KEY") or "failed_load"
        client = AnthropicModel(
            api_key=api_key,
            model=model,
            system_prompt=system_prompt,
            max_tokens=max_tokens,
            temperature=temperature,
        )
    else:
        model = os.getenv("OPENAI_MODEL") or "gpt-4o"
        api_key = os.getenv("OPENAI_API_KEY") or "failed_to_load"
        client = OpenAIModel(
            api_key=api_key,
            model=model,
            system_prompt=system_prompt,
            max_tokens=max_tokens,
            temperature=temperature,
        )

    while True:
        req = input("Question: ")

        if req in ["", "done", "exit", ":q", "quit", "q", "/done", "/exit"]:
            break
        elif req in ["/dump", "/spill", "/new"]:
            client.new_session()
        elif req.startswith("/save"):
            fname = req[6:]
            client.save(fname)
        elif req.startswith("/load"):
            fname = req[6:]
            client.load_file(fname)
        else:
            print("\n---\n")
            response, tokens = client.query(req)

            print(response)
            print("")
            print(tokens)
            print("")


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Chatbot interface parser.")
    parser.add_argument(
        "-a",
        "--use-anthropic",
        action="store_true",
        help="Use Anthropic models (default=false)",
    )
    parser.add_argument(
        "-m",
        "--max_tokens",
        type=int,
        default=2048,
        help="Max number of tokens available for completions.",
    )
    parser.add_argument(
        "-t",
        "--temperature",
        type=float,
        default=0.1,
        help="Temperature (creativity) for completions. Bounded t in [0, 1].",
    )

    args = parser.parse_args()
    event_loop(args)
