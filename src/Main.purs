module Main where

import Prelude

import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Halogen as H
import Halogen.Aff as HAff
import Halogen.HTML as HTML
import Halogen.HTML.Events as Event
import Halogen.HTML.CSS (style)
import Halogen.HTML.Properties as Prop
import Halogen.VDom.Driver (runUI)
import CSS as CSS
import CSS.Font as Font
import Data.NonEmpty ((:|))
import Data.Int (toNumber)
import Type.Proxy (Proxy(..))
import Web.CSSOM.MouseEvent (offsetX, offsetY)
import Control.Monad.Rec.Class (class MonadRec)
import Effect.Aff.Class (class MonadAff)

import Web.HTML.HTMLElement (offsetTop, offsetLeft)
import Effect.Console (logShow)
import Data.Profunctor.Strong ((&&&))
import Data.Tuple (uncurry)
import Data.Traversable (traverse_)

main :: Effect Unit
main = HAff.runHalogenAff do
  body <- HAff.awaitBody
  runUI rootComponent unit body

rootComponent :: forall query input output m. MonadEffect m => H.Component query input output m
rootComponent =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

type Point = { x :: Number, y :: Number }

type State = Point
data Action = Click Point
            | Ignore

type RootSlots :: forall k. k -> Row Type
type RootSlots m = ( canvas :: forall query. H.Slot query Void ComponentIndices )

_canvas :: Proxy "canvas"
_canvas = Proxy

data ComponentIndices = TheCanvas
                      | TheOtherCanvas
derive instance Eq ComponentIndices
derive instance Ord ComponentIndices

initialState :: forall input. input -> State
initialState _ = { x: 0.0, y: 0.0 }

handleAction :: forall output m. MonadEffect m => Action -> H.HalogenM State Action (RootSlots m) output m Unit
handleAction (Click {x, y}) = H.modify_ $ const {x, y}
handleAction Ignore = pure unit

render :: forall m. MonadEffect m => State -> H.ComponentHTML Action (RootSlots m) m
render _ = HTML.div_
  [ HTML.slot_ _canvas TheCanvas canvasssss { width: 500, height: 500 }
  , HTML.slot_ _canvas TheOtherCanvas canvasssss { width: 500, height: 500 }
  , HTML.h2_ [HTML.text "wip :3"]
  , attribution
  ]

cutesyFooterStyle :: CSS.CSS
cutesyFooterStyle = do
  CSS.fontFamily ["DejaVu Sans Mono"] (Font.monospace :| [])
  CSS.fontSize $ CSS.px 9.5

attribution :: forall w i. HTML.HTML w i
attribution = HTML.footer [style cutesyFooterStyle]
  [ HTML.p_ 
    [ HTML.text "made with "
    , HTML.b_ [HTML.text "halogen"]
    , HTML.text " and sheer force of will. (c) UnrelatedString 2025."
    ]
  , HTML.a [Prop.href "https://github.com/UnrelatedString/bingous"]
    [ HTML.text "github.com/UnrelatedString/bingous"
    ]
  ]

canvasssss :: forall query output m. MonadEffect m => H.Component query {width :: Int, height :: Int} output m
canvasssss =
  H.mkComponent
    { initialState: identity
    , render: \{width, height} -> HTML.canvas [Prop.width width, Prop.height height, Prop.ref (H.RefLabel "thelabel"), Event.onClick (const unit)]
    , eval: H.mkEval H.defaultEval { handleAction = \_ -> H.getHTMLElementRef (H.RefLabel "thelabel") >>= traverse_ \elem -> liftEffect do
      logShow =<< offsetTop elem
      logShow =<< offsetLeft elem }
    }
