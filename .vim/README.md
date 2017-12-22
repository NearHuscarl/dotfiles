# vim-config
personal vim settings

## Tips

### Regex

##### Negative Lookahead

```vim
/Foo\(Bar\)\@!
```

| Match  | No Match |
|:------:|:--------:|
| FooBaz |  FooBar  |
| FooQux |          |
| FooMuh |          |


##### Negative Lookbehind

```vim
/\(Foo\)\@<!Bar
```

| Match  | No Match |
|:------:|:--------:|
| BazBar |  FooBar  |
| QuxBar |          |
| MuhBar |          |

##### Positive lookahead:

```vim
/Foo\(Bar\)\@=
```

| Match  | No Match |
|:------:|:--------:|
| FooBar |  FooBaz  |
|        |  FooQux  |
|        |  FooMuh  |

##### Positive lookbehind

```vim
/\(Foo\)\@<=Bar
```

| Match  | No Match |
|:------:|:--------:|
| FooBar |  BazBar  |
|        |  QuxBar  |
|        |  MuhBar  |
