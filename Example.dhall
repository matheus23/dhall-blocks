let JSON =
      https://prelude.dhall-lang.org/JSON/package.dhall sha256:0c3c40a63108f2e6ad59f23b789c18eb484d0e9aebc9416c5a4f338c6753084b

let Block =
      ./src/Blocks/package.dhall sha256:bd8661ca59f750dfa5a64bee2ab3c9e9c3f9690fb89a1666e3466d58863b29c0

let renderYAML =
      ./src/Blocks/renderYAML.dhall sha256:3d0f379ea787cde8d2befd4a25486e88c62476d5dc6c62d3f51d6e2567d4a3f9

in  Block.toText
      ( renderYAML
          Text/show
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
