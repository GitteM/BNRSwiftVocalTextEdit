//: Chapter 20 - Error Handling
//: ===========================

/*:
- Classes of Errors
- Lexing an Input String
- Catching Errors
- Parsing the Token Array
- Handling Errors by Sticking Your Head in the Sand
- Swift Error Handling Philosophy
- 🏅 Bronze Challenge
- 🏅 Silver Challenge
- 🏅 Gold Challenge

*/

import Cocoa

//: Lexing an Input String
//: ----------------------

enum Token {
    case Number(Int)
    case Plus
}

class Lexer {
    
    enum Error: ErrorType {
        case InvalidCharacter(Character)
    }
    
    let input: String.CharacterView // A String's collection of Characters (extended grapheme clusters) elements.
    var position: String.CharacterView.Index
    
    init(input: String) {
        self.input = input.characters
        self.position = self.input.startIndex
    }
    
    func peek() -> Character? {
        guard position < input.endIndex else {
            return nil
        }
        return input[position]
    }
    
    func advance() {
        assert(position < input.endIndex, "cannot advance past the end")
        ++position
    }
    
    func getNumber() -> Int {
        var value = 0
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9" :
                let digitValue = Int(String(nextCharacter))!
                value = 10 * value + digitValue
                advance()
            default :
                //  A non-digit go back to regular lexing
                return value
            }
        }
        return value
    }
    
    func lex() throws -> [Token] {
        var tokens = [Token]()
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9" :
                let value  = getNumber()
                tokens.append(.Number(value))
            case "+" :
                tokens.append(.Plus)
                advance()
            case " " :
                advance()
            default:
                throw Error.InvalidCharacter(nextCharacter)
            }
        }
        return tokens
    }
}
/*
func evaluate(input: String) {
print("Evaluating: \(input)")
let lexer = Lexer(input: input)
let tokens = try? lexer.lex()
print("Lexer output \(tokens)")
}

evaluate("10 + 3 + 5")
evaluate("1 + 2 + abcdef")
*/

/*

//: Catching Errors
func evaluate(input: String) {
    print("Evaluating: \(input)")
    let lexer = Lexer(input: input)
    do {
        let tokens = try lexer.lex()
        print("Lexer output \(tokens)")
    } catch Lexer.Error.InvalidCharacter(let character) {
        print("Input contained an invalid character: \(character)")
    } catch {
        print("An eror occured: \(error)")
    }
}

evaluate("10 + 3 + 5")

*/

//: Parsing the Token Array
//: -----------------------

class Parser {
    
    enum Error: ErrorType {
        case UnexpectedEndOfInput
        case InvalidToken(Token)
    }
    
    let tokens: [Token]
    var position = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func getNextToken() -> Token? {
        guard position < tokens.count else {
            return nil
        }
        return tokens[position++]
    }
    
    func getNumber() throws -> Int {
        guard let token = getNextToken() else {
            throw Error.UnexpectedEndOfInput
        }
        
        switch token {
        case .Number(let value):
            return value
        case .Plus:
            throw Error.InvalidToken(token)
        }
    }
    
    func parse() throws -> Int {
        var value = try getNumber()
        
        while let token = getNextToken() {
            switch token {
            case .Plus:
                let nextNumber = try getNumber()
                value += nextNumber
            case .Number:
                throw Error.InvalidToken(token)
            }
        }
        return value
    }
}

/*
func evaluate(input: String) {
    print("Evaluating: \(input)")
    let lexer = Lexer(input: input)
    
    do {
        let tokens = try lexer.lex()
        print("Lexer output: \(tokens)")
        
        let parser = Parser(tokens: tokens)
        let result = try parser.parse()
        print("Parser output: \(result)")
        
    } catch Lexer.Error.InvalidCharacter(let character) {
        print("Input contained an invalid character: \(character)")
    } catch Parser.Error.UnexpectedEndOfInput {
        print("Unexpected end of input during parsing")
    } catch Parser.Error.InvalidToken(let token) {
        print("Invalid token during parsing: \(token)")
    } catch {
        print("error")
    }
}

// evaluate("10 + 3 + 5")
// evaluate("10 + 3 + aad")
// evaluate("10 + 3 +")
// evaluate("10 + 3 5")
*/

//: Handling Errors by Sticking Your Head in the Sand
//: -------------------------------------------------

/*
//: Using try?

func evaluate(input: String) {
    print("Evaluating: \(input)")
    let lexer = Lexer(input: input)
    guard let tokens = try? lexer.lex() else {
        print("Lexing failed, but I don't know why")
        return
    }

    do {
        print("Lexer output: \(tokens)")
        
        let parser = Parser(tokens: tokens)
        let result = try parser.parse()
        print("Parser output: \(result)")
        
    } catch Lexer.Error.InvalidCharacter(let character) {
        print("Input contained an invalid character: \(character)")
    } catch Parser.Error.UnexpectedEndOfInput {
        print("Unexpected end of input during parsing")
    } catch Parser.Error.InvalidToken(let token) {
        print("Invalid token during parsing: \(token)")
    } catch {
        print("error")
    }
}
*/

func evaluate(input: String) {
    print("Evaluating: \(input)")
    let lexer = Lexer(input: input)
    
    do {
        let tokens = try lexer.lex()
        print("Lexer output: \(tokens)")
        
        let parser = Parser(tokens: tokens)
        let result = try parser.parse()
        print("Parser output: \(result)")
        
    } catch Lexer.Error.InvalidCharacter(let character) {
        print("Input contained an invalid character: \(character)")
    } catch Parser.Error.UnexpectedEndOfInput {
        print("Unexpected end of input during parsing")
    } catch Parser.Error.InvalidToken(let token) {
        print("Invalid token during parsing: \(token)")
    } catch {
        print("An error occured: \(error)")
    }
}

 evaluate("10 + 3 + 5")
 evaluate("10 + 3 + aad")
 evaluate("10 + 3 +")
 evaluate("10 + 3 5")
