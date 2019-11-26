let Text/concatSep =
      https://prelude.dhall-lang.org/Text/concatSep sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let List/null =
      https://prelude.dhall-lang.org/List/null sha256:2338e39637e9a50d66ae1482c0ed559bbcc11e9442bfca8f8c176bbcd9c4fc80

let List/map =
      https://prelude.dhall-lang.org/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let List/concatMap =
      https://prelude.dhall-lang.org/List/concatMap sha256:3b2167061d11fda1e4f6de0522cbe83e0d5ac4ef5ddf6bb0b2064470c5d3fb64

let Optional/map =
      https://prelude.dhall-lang.org/Optional/map sha256:e7f44219250b89b094fbf9996e04b5daafc0902d864113420072ae60706ac73d

let NonEmptyList =
      let NonEmptyList =
            { Type =
                https://raw.githubusercontent.com/FormationAI/dhall-bhat/master/NonEmptyList/Type sha256:e2e247455a858317e470e0e4affca8ac07f9f130570ece9cb7ac1f4ea3deb87f
            , fromList =
                https://raw.githubusercontent.com/FormationAI/dhall-bhat/master/NonEmptyList/fromList sha256:95c363359a3a674d6e51376612ffa36eb7224d003b1b875b230ac64935c8d0bf
            , toList =
                https://raw.githubusercontent.com/FormationAI/dhall-bhat/master/NonEmptyList/toList sha256:0977fe14b77232a4451dcf409c43df4589c4b3cdde7b613aab8df183be1b53f5
            , append =
                  λ ( a
                    : Type
                    )
                → ( https://raw.githubusercontent.com/FormationAI/dhall-bhat/master/NonEmptyList/semigroup sha256:333a5cb9d6125589fe7ca2944f1a0df41903f9b5091f763a94048fb0f337950e
                      a
                  ).op
            }
      
      in    NonEmptyList
          ∧ { concat =
                  λ(a : Type)
                → λ(lss : NonEmptyList.Type (NonEmptyList.Type a))
                → { head = lss.head.head
                  , tail =
                        lss.head.tail
                      # List/concatMap
                          (NonEmptyList.Type a)
                          a
                          (NonEmptyList.toList a)
                          lss.tail
                  }
            }

in  NonEmptyList
