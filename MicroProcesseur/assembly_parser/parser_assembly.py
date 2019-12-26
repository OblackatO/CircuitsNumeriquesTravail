from typing import List
from AssemblyParser import AssemblyParser
import sys


def main():
    parser = AssemblyParser(sys.argv[1])
    parser.InitTranslationFlow()


if __name__ == "__main__":
    main()

