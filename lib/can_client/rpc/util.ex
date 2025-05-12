defmodule CanClient.Rpc.Util do
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
      dashboards: Enum.map(dashboards, &convert_dashboard/1),
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
  # Skip other widget types
  defp convert_widget(_), do: nil

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

  # Convert layout
  defp convert_layout(%{"x" => x, "y" => y, "w" => w, "h" => h}) do
    %CanClient.LayoutInfo{
      x: x,
      y: y,
      w: w,
      h: h
    }
  end

  # Convert gauge zone
  defp convert_gauge_zone(%{"start" => start, "end" => end_val, "color" => color}) do
    %CanClient.GaugeZone{
      start: start,
      end: end_val,
      color: color
    }
  end
end
