class Game {
    COLORS = ["red", "green", "blue"]
    reds = []; greens = []; blues = []
    constructor(number, game) {
        this.number = number
        this.game = game
        for(var g of this.game.split(';')) {
            this.COLORS.map((c) => {
                let n = Number(g.split(',').filter(p => p.includes(c))[0]?.replace(c,''));
                eval(`this.${c}s.push(${n})`);
            });
        }
    }

    get MaxR() {
        return Math.max(...this.reds.filter(n => Number(n)))
    }
    get MaxG() {
        return Math.max(...this.greens.filter(n => Number(n)))
    }
    get MaxB() {
        return Math.max(...this.blues.filter(n => Number(n)))
    }
    get GameNum() {
        return Number(this.number.replace('Game ',''))
    }
    get MinSetPower() {
        return this.MaxR * this.MaxG * this.MaxB
    }
}

class WinnerFinder {
    MINIMUMS = {"red": 12, "green": 13, "blue": 14}
    constructor(gamelog) {
        this.games = []
        gamelog.split("\r\n").map(g => {
            this.games.push(new Game(g.split(':')[0], g.split(':')[1]))
         } )
    }
    get Winners() {
        return this.games.filter(g =>
            g.MaxR <= this.MINIMUMS.red &&
            g.MaxG <= this.MINIMUMS.green &&
            g.MaxB <= this.MINIMUMS.blue
        )
    }

    get Total() {
        return this.Winners.reduce((p, w) => p + w.GameNum, 0);
    }

    get PowerSum() {
        return this.games.reduce((p, g) => p + g.MinSetPower, 0);
    }
}
var fs = require('fs');
try {  
    var data = fs.readFileSync('input', 'utf8');
    var finder = new WinnerFinder(data)
     console.log("Part 1: " + finder.Total)
     console.log("Part 2: " + finder.PowerSum)
} catch(e) {
    console.log('Error:', e.stack);
}
