using Dash

app = dash()

app.layout = html_div() do
    html_h1("Hello Dash"),
    html_div("Dash.jl: Julia interface for Dash"),
    dcc_graph(id = "example-graph",
              figure = (
                  data = [
                      (x = [1, 2, 3], y = [4, 1, 2], type = "bar", name = "Data1"),
                      (x = [1, 2, 3], y = [2, 4, 5], type = "bar", name = "Data2"),
                  ],
                  layout = (title = "Dash Data Visualization",)
              ))
end

run_server(app, "0.0.0.0", 8080)