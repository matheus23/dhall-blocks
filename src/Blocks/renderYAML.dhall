let JSON =
      https://prelude.dhall-lang.org/JSON/package.dhall sha256:0c3c40a63108f2e6ad59f23b789c18eb484d0e9aebc9416c5a4f338c6753084b

let List/map =
      https://prelude.dhall-lang.org/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let Block = ./package.dhall

let renderYAML
    : (Text → Text) → JSON.Type → Block.Type
    =   λ(escapeObjectKey : Text → Text)
      → λ(json : JSON.Type)
      → let ObjectField = { mapKey : Text, mapValue : Block.Type }
        
        in  json
              Block.Type
              { string = λ(x : Text) → Block.singleLine (Text/show x)
              , number = λ(x : Double) → Block.singleLine (Double/show x)
              , object =
                    λ(fields : List ObjectField)
                  → Block.many
                      (Block.singleLine "{}")
                      ( List/map
                          ObjectField
                          Block.Type
                          (   λ(e : ObjectField)
                            → Block.indentKeyed
                                "${escapeObjectKey e.mapKey}:"
                                " "
                                "  "
                                e.mapValue
                          )
                          fields
                      )
              , array =
                    λ(elements : List Block.Type)
                  → Block.many
                      (Block.singleLine "[]")
                      ( List/map
                          Block.Type
                          Block.Type
                          (Block.indentWith "- " "  ")
                          elements
                      )
              , bool =
                  λ(x : Bool) → Block.singleLine (if x then "true" else "false")
              , null = Block.singleLine "null"
              }

let exampleEscapedKeys =
        assert
      :   Block.toText
            ( renderYAML
                (λ(key : Text) → "! ${Text/show key}")
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
        ≡ ''
          - true
          - "Hello"
          - ! "foo": null
            ! "bar": 1.0
          ''

let exampleUnescapedKeys =
        assert
      :   Block.toText
            ( renderYAML
                (λ(key : Text) → key)
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
        ≡ ''
          - true
          - "Hello"
          - foo: null
            bar: 1.0
          ''

let exampleQuotedKeys =
        assert
      :   Block.toText
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
        ≡ ''
          - true
          - "Hello"
          - "foo": null
            "bar": 1.0
          ''

in  renderYAML
