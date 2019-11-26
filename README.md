# dhall-blocks

This utility grew out of the `JSON.renderYAML` function from the [Dhall Prelude](https://github.com/dhall-lang/dhall-lang/blob/master/Prelude/JSON/renderYAML).

I wanted the `Block` abstraction for building indentable text blocks to be accessible for anyone who wants to use it. In the Prelude it is hidden inside the `renderYAML` scope.

I also wanted more configurability for the `renderYAML` function, as there is quite a design space for different solutions.

Other features include:
* Being able to configure how yaml key escaping should work
* Inspecting the result of `renderYAML` as it returns a `Block` (instead of `Text` as in the Prelude's renderYAML).

## Usage

```dhall
let JSON =
      https://prelude.dhall-lang.org/JSON/package.dhall sha256:0c3c40a63108f2e6ad59f23b789c18eb484d0e9aebc9416c5a4f338c6753084b

let Block =
      https://raw.githubusercontent.com/matheus23/dhall-blocks/master/src/Blocks/package.dhall sha256:bd8661ca59f750dfa5a64bee2ab3c9e9c3f9690fb89a1666e3466d58863b29c0

let renderYAML =
      https://raw.githubusercontent.com/matheus23/dhall-blocks/master/src/Blocks/renderYAML.dhall sha256:3d0f379ea787cde8d2befd4a25486e88c62476d5dc6c62d3f51d6e2567d4a3f9

in  Block.toText
      ( renderYAML
          Text/show -- Configure your own key escaping using this function
          ( JSON.array
              [ JSON.bool True
              , JSON.string "Hello"
              , JSON.object
                  [ { mapKey = "foo", mapValue = JSON.null }
                  , { mapKey = "bar", mapValue = JSON.number 1.0 }
                  ]
              ]
          )
      )
```

Above dhall expression results in the following text output (using `dhall text --file `[`Example.dhall`](./Example.dhall))

```yaml
- true
- "Hello"
- "foo": null
  "bar": 1.0
```
