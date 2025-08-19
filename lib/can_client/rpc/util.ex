defmodule CanClient.Rpc.Util do
  require Logger

  def api_to_proto(%{
        "id" => id,
        "name" => name,
        "avatar" => avatar,
        "dbc_defs" => dbc_defs,
        "dashboards" => dashboards,
        "uid" => uid
      }) do
    %CanClient.Vehicle{
      name: name,
      avatar: avatar,
      dbc_defs: Enum.map(dbc_defs, &convert_dbc_def/1),
      dashboards:
        dashboards
        |> Enum.filter(fn d -> Map.get(d, "in_car", true) end)
        |> Enum.map(&convert_dashboard/1),
      uid: uid
    }
  end

  # Convert DBC definition
  defp convert_dbc_def(%{
         "content" => content,
         "filename" => filename,
         "messages" => messages
       }) do
    %CanClient.DBCDef{
      content: content,
      filename: filename,
      messages: Enum.map(messages, &convert_message/1)
    }
  end

  # Convert DBC message
  defp convert_message(%{
         "can_id" => can_id,
         "signals" => signals
       }) do
    %CanClient.DBCMessage{
      can_id: can_id,
      signals: Enum.map(signals, &convert_signal/1)
    }
  end

  # Convert signal
  defp convert_signal(%{
         "name" => name,
         "unit" => unit,
         "range_min" => range_min,
         "range_max" => range_max
       }) do
    %CanClient.Signal{
      name: name,
      unit: unit,
      range_min: range_min,
      range_max: range_max
    }
  end

  # Convert dashboard
  defp convert_dashboard(%{
         "uid" => uid,
         "name" => name,
         "widgets" => widgets
       }) do
    %CanClient.Dashboard{
      uid: uid,
      name: name,
      widgets: Enum.map(widgets, &convert_widget/1) |> Enum.filter(&(&1 != nil))
    }
  end

  # Convert widget based on component type
  defp convert_widget(%{"component" => "line_chart"} = widget),
    do: convert_line_chart_widget(widget)

  defp convert_widget(%{"component" => "gauge"} = widget), do: convert_gauge_widget(widget)

  defp convert_widget(%{"component" => "message_button"} = widget),
    do: convert_message_widget(widget)

  # Skip other widget types
  defp convert_widget(%{"component" => c}) do
    Logger.warning("Unhandled widget #{c}")
    nil
  end

  # Convert LineChartWidget
  defp convert_line_chart_widget(%{
         "title" => title,
         "columns" => columns,
         "layout" => layout
       }) do
    %CanClient.DashWidget{
      widget:
        {:line_chart,
         %CanClient.LineChartWidget{
           title: title,
           columns: columns,
           layout: convert_layout(layout)
         }}
    }
  end

  # Convert GaugeWidget
  defp convert_gauge_widget(%{
         "title" => title,
         "columns" => columns,
         "layout" => layout,
         "style" => style
       }) do
    %CanClient.DashWidget{
      widget:
        {:gauge,
         %CanClient.GaugeWidget{
           title: title,
           columns: columns,
           layout: convert_layout(layout),
           style: %{
             zones: Enum.map(Map.get(style, "zones", []), &convert_gauge_zone/1),
             style_type: Map.get(style, "styleType", "linear")
           }
         }}
    }
  end

  defp convert_message_widget(%{
         "layout" => layout
       }) do
    %CanClient.DashWidget{
      widget:
        {:message_pane,
         %CanClient.MessagePaneWidget{color: "#00ff00", layout: convert_layout(layout)}}
    }
  end

  # Convert layout
  defp convert_layout(%{"x" => x, "y" => y, "w" => w, "h" => h}) do
    %CanClient.LayoutInfo{
      x: x,
      y: y,
      w: w,
      h: h
    }
  end

  defp to_float(b) when is_binary(b) do
    {f, _} = Float.parse(b)
    f
  end

  defp to_float(f) when is_float(f), do: f
  defp to_float(i) when is_integer(i), do: i * 1.0
  defp to_float(nil), do: nil

  # Convert gauge zone
  defp convert_gauge_zone(%{"start" => start, "end" => end_val, "color" => color}) do
    %CanClient.GaugeZone{
      start: to_float(start),
      end: to_float(end_val),
      color: color
    }
  end

  def to_event(%{
        "type" => "message",
        "payload" => %{
          "message" => message,
          "textColor" => text_color,
          "backgroundColor" => background_color,
          "textSize" => size,
          "flash" => flash
        }
      }) do
    %CanClient.EventValue{
      event: {
        :message_event,
        %CanClient.TextEvent{
          message: message,
          backgroundColor: background_color,
          flash: flash,
          textColor: text_color,
          textSize: size
        }
      }
    }
  end

  def to_event(%{
        "type" => "alert",
        "payload" => %{
          "level" => level,
          "message" => message
        }
      }) do
    %CanClient.EventValue{
      event: {
        :alert_event,
        %CanClient.AlertEvent{
          level: level,
          message: message
        }
      }
    }
  end
end
