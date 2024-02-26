struct Symbol: Equatable {
    enum SymbolType {
        case suite
        case subscenario
        case scenario
    }
    let type: SymbolType
    let name: Token
}

final class Scope {
    enum ScopeType {
        case global
        case suite
        case subscenario
    }

    let type: ScopeType
    let name: String
    weak var parentScope: Scope?
    var childScopes: [Scope] = []
    private var symbols: [Symbol] = []

    init(
        parentScope: Scope?,
        type: ScopeType,
        name: String
    ) {
        self.parentScope = parentScope
        self.type = type
        self.name = name
    }

    func declareSymbol(_ symbol: Symbol) {
        symbols.append(symbol)
    }

    func isSymbolCollided(_ symbol: Symbol) -> Bool {
        for s in symbols {
            if s.type == symbol.type && s.name.lexeme == symbol.name.lexeme && s.name != symbol.name {
                return true
            }
        }
        return false
    }

    func isSymbolDeclared(type: Symbol.SymbolType, name: String) -> Bool {
        for s in symbols {
            if s.type == type && s.name.lexeme == name {
                return true
            }
        }
        return false
    }

    func printTree(level: Int = 0) {
        let indentation = String(repeating: "  ", count: level)
        Swift.print("\(indentation)\(type) Scope: '\(name)'")

        if !symbols.isEmpty {
            Swift.print("\(indentation)  Symbols:")
            for symbol in symbols {
                Swift.print("\(indentation)    \(symbol.name.lexeme) (\(symbol.type))")
            }
        }

        if !childScopes.isEmpty {
            Swift.print("\(indentation)  Child Scopes:")
            for child in childScopes {
                child.printTree(level: level + 1)
            }
        }
    }
}
