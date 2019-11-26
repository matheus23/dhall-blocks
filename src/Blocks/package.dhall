let Text/concatSep =
      https://prelude.dhall-lang.org/Text/concatSep sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let List/null =
      https://prelude.dhall-lang.org/List/null sha256:2338e39637e9a50d66ae1482c0ed559bbcc11e9442bfca8f8c176bbcd9c4fc80

let List/map =
      https://prelude.dhall-lang.org/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let NonEmptyList = ../NonEmptyList.dhall

let Block/Type
    : Type
    = NonEmptyList.Type Text

let indentWith
    : Text → Text → Block/Type → Block/Type
    =   λ(headIndent : Text)
      → λ(tailIndent : Text)
      → λ(block : Block/Type)
      → { head = headIndent ++ block.head
        , tail = List/map Text Text (λ(t : Text) → tailIndent ++ t) block.tail
        }

let many
    : Block/Type → List Block/Type → Block/Type
    =   λ(ifEmpty : Block/Type)
      → λ(blocks : List Block/Type)
      → Optional/fold
          (NonEmptyList.Type Block/Type)
          (NonEmptyList.fromList Block/Type blocks)
          Block/Type
          (NonEmptyList.concat Text)
          ifEmpty

let singleLine
    : Text → Block/Type
    = λ(text : Text) → { head = text, tail = [] : List Text }

let indentKeyed
    : Text → Text → Text → Block/Type → Block/Type
    =   λ(key : Text)
      → λ(spacer : Text)
      → λ(indentation : Text)
      → λ(block : Block/Type)
      →       if List/null Text block.tail
        
        then  singleLine (key ++ spacer ++ block.head)
        
        else  indentWith
                key
                indentation
                { head = "", tail = NonEmptyList.toList Text block }

let toText
    : Block/Type → Text
    =   λ(block : Block/Type)
      → Text/concatSep "\n" (NonEmptyList.toList Text block) ++ "\n"

in  { Type = Block/Type
    , indentWith = indentWith
    , many = many
    , singleLine = singleLine
    , indentKeyed = indentKeyed
    , toText = toText
    }
