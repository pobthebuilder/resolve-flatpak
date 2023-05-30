class Version:
    def __init__(self, major: int, minor: int, patch: int, beta: int, build: int):
        self.major = major
        self.minor = minor
        self.patch = patch
        self.beta = beta
        self.build = build

    def __str__(self):
        return f"""{self.major}.{self.minor}.{self.patch}{"" if self.beta == -1 else f".{self.beta}+{self.build}"}"""
