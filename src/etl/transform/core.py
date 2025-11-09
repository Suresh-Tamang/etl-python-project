from typing import Iterable, Iterator
from ...models import User

def normalize_users(rows: Iterable[dict]) -> Iterator[User]:
    for row in rows:
        yield User(**row)