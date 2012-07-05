function decorateTooltips( ) {

    $(".standard-tooltip").qtip( {
        position: { adjust: { screen: true } },
        style: { border: { color: '#000', width: 1, radius: 3 } },
        show: { delay: 150, effect: { type: 'slide' } },
        hide: { delay: 250, effect: { type: 'slide' } }
    });

}