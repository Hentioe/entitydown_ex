defmodule Entitydown.TextLinkRuleTest do
  use ExUnit.Case
  doctest Entitydown

  alias Entitydown.State

  import Entitydown.TextLinkRule

  test "match/1" do
    state = %State{
      line: %State.Line{
        src: "\\[",
        len: 1
      },
      pos: 0
    }

    {:nomatch, _} = match(state)

    src = "[我是链接文本][]]]]](我是链接地址)"

    state = %State{
      line: %State.Line{
        src: src,
        len: String.length(src)
      },
      pos: 0
    }

    {:match, state} = match(state)

    assert state.pos == String.length(src)

    assert state.entities == [
             %Entitydown.Entity{
               type: :text_link,
               content: "我是链接文本][]]]]",
               url: "我是链接地址"
             }
           ]

    src = "[我是链接文本][]]]]\\()](我是链接地址\\))"

    state = %State{
      line: %State.Line{
        src: src,
        len: String.length(src)
      },
      pos: 0
    }

    {:match, state} = match(state)

    assert state.pos == String.length(src)

    assert state.entities == [
             %Entitydown.Entity{
               type: :text_link,
               content: "我是链接文本][]]]]\\()",
               url: "我是链接地址\\)"
             }
           ]

    src = "[Telegram 的主页](https://t.me/)"

    state = %State{
      line: %State.Line{
        src: src,
        len: String.length(src)
      },
      pos: 0
    }

    {:match, state} = match(state)

    assert state.pos == String.length(src)

    assert state.entities == [
             %Entitydown.Entity{
               type: :text_link,
               content: "Telegram 的主页",
               url: "https://t.me/"
             }
           ]
  end
end
