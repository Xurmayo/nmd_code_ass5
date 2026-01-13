// MARK: - Fighter Protocol
protocol Fighter {
    var name: String { get }
    var hp: Int { get set }
    var power: Int { get }
    func attack() -> Int
    func takeDamage(_ amount: Int)
}

print("Fighter protocol created")

// MARK: - Universe Enum
enum Universe {
    case attackOnTitan
    case jujutsuKaisen
    case demonSlayer

    var title: String {
        switch self {
        case .attackOnTitan: return "Attack on Titan"
        case .jujutsuKaisen: return "Jujutsu Kaisen"
        case .demonSlayer: return "Demon Slayer"
        }
    }
}

let u = Universe.attackOnTitan
print("Universe enum ready: \(u.title)")

// MARK: - Base Character Class
class Character: Fighter {
    let name: String
    var hp: Int
    let power: Int
    let universe: Universe

    private var shield: Int = 0

    var shieldPoints: Int {
        get { shield }
        set {
            if newValue >= 0 && newValue <= 100 {
                shield = newValue
            }
        }
    }

    init(name: String, hp: Int, power: Int, universe: Universe) {
        self.name = name
        self.hp = hp
        self.power = power
        self.universe = universe
    }

    func attack() -> Int {
        return power
    }

    func takeDamage(_ amount: Int) {
        var remaining = amount

        if shield > 0 {
            let absorbed = min(shield, remaining)
            shield -= absorbed
            remaining -= absorbed
            print("\(name)'s shield absorbed \(absorbed). Shield now: \(shield)")
        }

        hp = max(0, hp - remaining)
        print("\(name) took \(remaining) damage. HP now: \(hp)")
    }

    func status() {
        print("Name: \(name) | HP: \(hp) | Power: \(power) | Shield: \(shield) | Universe: \(universe.title)")
    }
}

// MARK: - Subclasses
class TitanShifter: Character {
    let titanForm: String

    init(name: String, hp: Int, power: Int, titanForm: String) {
        self.titanForm = titanForm
        super.init(name: name, hp: hp, power: power, universe: .attackOnTitan)
    }

    override func attack() -> Int {
        return power + 15
    }
}

class Sorcerer: Character {
    let cursedEnergy: Int

    init(name: String, hp: Int, power: Int, cursedEnergy: Int) {
        self.cursedEnergy = cursedEnergy
        super.init(name: name, hp: hp, power: power, universe: .jujutsuKaisen)
    }

    override func attack() -> Int {
        return power + (cursedEnergy / 10)
    }
}

// MARK: - Characters
let eren = TitanShifter(name: "Eren", hp: 120, power: 30, titanForm: "Attack Titan")
eren.shieldPoints = 30

let gojo = Sorcerer(name: "Gojo", hp: 90, power: 25, cursedEnergy: 100)
gojo.shieldPoints = 15

let mikasa = Character(name: "Mikasa", hp: 90, power: 20, universe: .attackOnTitan)

let characters: [Character] = [eren, gojo, mikasa]

// MARK: - Print Characters
print("\n--- Characters ---")
characters.forEach {
    $0.status()
    print("Attack damage: \($0.attack())\n")
}

// MARK: - Healable Protocol
protocol Healable {
    func heal() -> Int
}

extension Healable {
    func heal() -> Int { 10 }
}

extension Sorcerer: Healable {
    func heal() -> Int {
        return 25
    }
}

print("Healed for: \(gojo.heal())")

// MARK: - Battle Logger
protocol BattleLoggerDelegate: AnyObject {
    func didStartBattle(_ a: String, _ b: String)
    func didEndBattle(winner: String)
}

class BattleLogger: BattleLoggerDelegate {
    func didStartBattle(_ a: String, _ b: String) {
        print("\nBattle started: \(a) vs \(b)")
    }

    func didEndBattle(winner: String) {
        print("Winner: \(winner)")
    }
}

// MARK: - Battle Arena
class BattleArena {
    weak var delegate: BattleLoggerDelegate?

    func fight(_ a: Character, _ b: Character) {
        delegate?.didStartBattle(a.name, b.name)

        for round in 1...3 {
            print("\nRound \(round):")
            b.takeDamage(a.attack())
            if b.hp == 0 { break }

            a.takeDamage(b.attack())
            if a.hp == 0 { break }
        }

        let winner = a.hp > b.hp ? a.name : b.name
        delegate?.didEndBattle(winner: winner)
    }
}

let logger = BattleLogger()
let arena = BattleArena()
arena.delegate = logger

// MARK: - Errors
enum BattleError: Error {
    case sameFighter
    case deadFighter
    case invalidPower
}

func validateForBattle(_ a: Character, _ b: Character) throws {
    if a.name == b.name { throw BattleError.sameFighter }
    if a.hp == 0 || b.hp == 0 { throw BattleError.deadFighter }
    if a.power <= 0 || b.power <= 0 { throw BattleError.invalidPower }
}

// MARK: - Start Battle
do {
    try validateForBattle(eren, gojo)
    arena.fight(eren, gojo)
} catch BattleError.deadFighter {
    print("Error: dead fighter cannot battle")
} catch BattleError.sameFighter {
    print("Error: same fighter")
} catch {
    print("Error: invalid power")
}

// MARK: - Generics
func pickRandom<T>(_ items: [T]) -> T? {
    return items.randomElement()
}

if let randomChar = pickRandom(characters) {
    print("\nRandom character: \(randomChar.name)")
}

let universes: [Universe] = [.attackOnTitan, .jujutsuKaisen, .demonSlayer]
if let randomUni = pickRandom(universes) {
    print("Random universe: \(randomUni.title)")
}

// MARK: - Functional Programming
print("\nFunctional Programming results:")

let mapped = characters.map { "\($0.name) (HP: \($0.hp))" }
print("map ->", mapped)

let filtered = characters.filter { $0.hp > 50 }
print("filter ->", filtered.map { $0.name })

let sorted = characters.sorted { $0.power > $1.power }
print("sorted ->", sorted.map { "\($0.name): \($0.power)" })
