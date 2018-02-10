function [Blotter, Hold] = createBlotter(names, lastPrices, InitHold, InitP, SR_pwgt, Wealth, pbuy, psell)

    Blotter = dataset({lastPrices','Prices'}, {InitHold,'InitHolding'}, {InitP,'InitPort'}, 'obsnames', names);

    SR_pwgt(abs(SR_pwgt) < 1.0e-3) = 0;% zero out near 0 trade weights
    Blotter.Portfolio = SR_pwgt;
    Hold = Wealth * (SR_pwgt ./ lastPrices');% zero out near 0 trade weights
    Hold(abs(Hold) < 1.0e-5) = 0;
    Blotter.Holding = Hold;
    Blotter.BuyShare = Wealth * (pbuy ./ lastPrices');
    Blotter.SellShare = Wealth * (psell ./ lastPrices');

end

