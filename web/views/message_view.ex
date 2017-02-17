defmodule UcxChat.MessageView do
  use UcxChat.Web, :view
  import Phoenix.HTML.Tag, only: [content_tag: 2, content_tag: 3, tag: 1, tag: 2]

  alias UcxChat.Message

  require Logger

  def file_upload_allowed_media_types do
    ""
  end

  def get_not_subscribed_templ(_mb) do
    %{}
  end

  def get_message_wrapper_opts(msg, client) do
    cls =
    ~w(get_sequential get_system get_t get_own get_is_temp get_chat_opts get_custom_class)a
    |> Enum.reduce("message background-transparent-dark-hover", fn fun, acc ->
      acc <> apply(__MODULE__, fun, [msg, client])
    end)
    attrs = [
      id: "message-#{msg.id}",
      class: cls,
      "data-username": msg.client.nickname,
      "data-groupable": msg.is_groupable,
      "data-date": format_date(msg.updated_at),
      "data-timestamp": msg.timestamp
    ]
    Phoenix.HTML.Tag.tag(:li, attrs)
  end
  def format_date(%NaiveDateTime{} = dt) do
    Message.format_date dt
  end
  def format_date(%{updated_at: dt}) do
    Message.format_date dt
  end
  def format_timestamp(%NaiveDateTime{} = dt) do
    Message.format_timestamp dt
  end
  def format_time(%{updated_at: dt}) do
    Message.format_time dt
  end
  def format_date_time(%{updated_at: dt}) do
    Message.format_date_time dt
  end
  def get_avatar(_msg) do
    ""
  end
  def avatar_from_username(_msg), do: false
  def emoji(_msg) do
    false
  end
  def get_username(msg), do: msg.client.nickname
  def get_users_typing(_msg), do: []
  def get_users_typing(_msg, _cmd), do: []
  def alias?(_msg), do: false
  def role_tags(_user), do: []
  def is_bot(_msg), do: false
  def get_date_time(msg), do: format_date_time(msg)
  def get_time(msg), do: format_time(msg)
  def edited(_msg), do: false
  def private(_msg), do: false
  def hide_cog(_msg), do: ""
  def attachments(_msg), do: []
  def hide_action_links(_msg), do: " hidden"
  def action_links(_msg), do: []
  def hide_reactions(_msg), do: " hidden"
  def reactions(_msg), do: []
  def mark_user_reaction(_reaction), do: ""
  def render_emoji(_emoji), do: ""
  def has_oembed(_msg), do: false

  def get_sequential(%{sequential: true}, _), do: " sequential"
  def get_sequential(_, _), do: ""
  def get_system(%{system: system}, _), do: "#{system}"
  def get_system(_, _), do: ""
  def get_t(%{t: t}, _), do: "#{t}"
  def get_t(_, _), do: ""
  def get_own(%{client_id: id}, %{id: id}), do: " own"
  def get_own(_, _), do: ""
  def get_is_temp(%{is_temp: is_temp}, _), do: "#{is_temp}"
  def get_is_temp(_, _), do: ""
  def get_chat_opts(%{chat_opts: chat_opts}, _), do: "#{chat_opts}"
  def get_chat_opts(_, _), do: ""
  def get_custom_class(%{custom_class: custom_class}, _), do: "#{custom_class}"
  def get_custom_class(_, _), do: ""

  def get_mb do
    [:subscribed, :allowed_to_send, :max_message_length, :show_file_upload, :katex_syntax,
     :show_sandstorm, :show_location, :show_mic, :show_v_rec, :is_blocked_or_blocker,
     :allowed_to_send, :show_formatting_tips, :show_mark_down, :show_markdown_code, :show_markdown]
    |> Enum.map(&({&1, true}))
    |> Enum.into(%{})
    # - if nst[:template] do
    # = render nst[:template]
    # - if nst[:can_join] do
    # = nst[:room_name]
    # - if nst[:join_code_required] do
  end

  def show_formatting_tips(%{show_formatting_tips: true} = mb) do
    content_tag :div, class: "formatting-tips", "aria-hidden": "true", dir: "auto" do
      [
        show_markdown1(mb),
        show_markdown_code(mb),
        show_katax_syntax(mb),
        show_markdown2(mb)
      ]
    end
  end
  def show_formatting_tips(_), do: ""

  def show_katax_syntax(%{katex_syntax: true}) do
    content_tag :span do
      content_tag :a, href: "https://github.com/Khan/KaTeX/wiki/Function-Support-in-KaTeX", target: "_blank" do
        "\[KaTex\]"
      end
    end
  end
  def show_katax_syntax(_), do: []

  def show_markdown1(%{show_mark_down: true}) do
    [
      content_tag(:b, "*bold*"),
      content_tag(:i, "_italics_"),
      content_tag(:span, do: ["~", content_tag(:strike, "strike"), "~"])
    ]
  end
  def show_markdown1(_), do: []

  def show_markdown2(%{show_mark_down: true}) do
    content_tag :q do
      [ hidden_br(), ">quote" ]
    end
  end
  def show_markdown2(_), do: []

  def show_markdown_code(%{show_markdown_code: true}) do
    [
      content_tag(:code, [class: "code-colors inline"], do: "`inline_code`"),
      show_markdown_code1()
    ]
  end
  def show_markdown_code(_), do: []

  def show_markdown_code1 do
    content_tag :code, class: "code-colors inline" do
      [
        hidden_br(),
        "```",
        hidden_br(),
        content_tag :i,  class: "icon-level-down" do
        end,
        "multi",
        hidden_br(),
        content_tag :i,  class: "icon-level-down" do
        end,
        "line",
        hidden_br(),
        content_tag :i,  class: "icon-level-down" do
        end,
        "```"
      ]
    end
  end

  defp hidden_br do
    content_tag :span, class: "hidden-br" do
      tag :br
    end
  end

  def is_popup_open(%{open: true}), do: true
  def is_popup_open(_), do: false

  def get_popup_cls(_chatd) do
    ""
  end
  def get_loading(_chatd) do
    false
  end
  def get_popup_title(%{title: title}), do: title
  def get_popup_title(_), do: false

  def get_popup_data(%{data: data}), do: data
  def get_popup_data(_), do: false
end