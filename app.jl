module App
    using Main.StatisticAnalysis
    using GenieFramework, PlotlyBase
    @genietools

    @app begin
        @out trace = [histogram(x=[])]
        @out layout = PlotlyBase.Layout(title="Histogram plot")
        @in N = 0
        @out m = 0.0
        @onchange N begin
            x = gen_numbers(N)
            m = calc_mean(x)
            trace = [histogram(x=x)]
        end
    end

    function ui()
        row([
            cell(class="st-col col-12", [
                h1("A simple dashboard"),
                slider(1:1:1000, :N),
                p("The average of {{N}} random numbers is {{m}}", class="st-module"),
                plot(:trace, layout=:layout)
            ])
        ])
    end

    @page("/", ui)
end