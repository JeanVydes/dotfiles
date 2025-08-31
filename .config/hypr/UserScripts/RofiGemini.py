#!/usr/bin/env python3

import time
import sys

# The hardcoded text to "stream"
QUOTE = "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal."

def simulate_streaming(prompt):
    """
    Simulates a streaming response by printing a few words at a time
    and flushing the output.
    """
    # First, echo the prompt to show it was received
    print(f"Query: {prompt}\n\nAI: ", end="", flush=True)

    words = QUOTE.split()
    for word in words:
        # Print the word followed by a space, without a newline
        print(word, end=' ', flush=True)
        # Simulate the delay of receiving a token from the API
        time.sleep(0.05)
    
    # Print a final newline to ensure the output buffer is fully flushed
    print()

if __name__ == "__main__":
    # Read the prompt from standard input (from the shell script)
    user_prompt = sys.stdin.read().strip()
    if user_prompt:
        simulate_streaming(user_prompt)