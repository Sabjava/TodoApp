import Foundation

struct Todo: CustomStringConvertible, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var description: String { (isCompleted ? "✅" : "❌") + " \(title)" }
}

protocol Cache {
    func save(todos: [Todo]) -> Bool
    func load() -> [Todo]?
}

final class FileSystemCache: Cache {
    private let url: URL
    
    init(filename: String = "todos.json") {
        // Uses the directory from which the application is executed
        url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(filename)
    }
    
    func save(todos: [Todo]) -> Bool {
        guard let data = try? JSONEncoder().encode(todos) else { return false }
        do { 
            try data.write(to: url)
            return true 
        } catch { 
            return false 
        }
    }
    
    func load() -> [Todo]? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([Todo].self, from: data)
    }
}

final class InMemoryCache: Cache {
    private var todos: [Todo]?
    func save(todos: [Todo]) -> Bool { self.todos = todos; return true }
    func load() -> [Todo]? { todos }
}

final class TodosManager {
    private var todos: [Todo]
    private let cache: Cache
    init(cache: Cache) {
        self.cache = cache
        todos = cache.load() ?? []
    }
    func listTodos() {
        if todos.isEmpty { print("🌟 No todos yet!"); return }
        print("📝 Todos:")
        for (i, todo) in todos.enumerated() { print("  [\(i)] \(todo)") }
    }
    func add(_ title: String) {
        todos.append(Todo(id: UUID(), title: title, isCompleted: false))
        _ = cache.save(todos: todos)
        print("📌 Added: \(title)")
    }
    func toggleCompletion(at index: Int) {
        guard todos.indices.contains(index) else { print("❗ Invalid index"); return }
        todos[index].isCompleted.toggle()
        _ = cache.save(todos: todos)
        print("\(todos[index])")
    }
    func delete(at index: Int) {
        guard todos.indices.contains(index) else { print("❗ Invalid index"); return }
        let title = todos[index].title
        todos.remove(at: index)
        _ = cache.save(todos: todos)
        print("🗑️ Deleted: \(title)")
    }
}

final class App {
    enum Command: String { case add, list, toggle, delete, exit }
    private let manager: TodosManager
    init(manager: TodosManager) { self.manager = manager }
    func run() {
        print("🌟 Welcome to Todos CLI!")
        while true {
            print("Commands: add, list, toggle, delete, exit")
            guard let input = readLine(), !input.isEmpty else { continue }
            let parts = input.split(separator: " ", maxSplits: 1).map(String.init)
            guard let command = Command(rawValue: parts[0].lowercased()) else { print("❗ Unknown command"); continue }
            switch command {
            case .add:
                guard parts.count > 1, !parts[1].isEmpty else { print("❗ Title required"); continue }
                manager.add(parts[1])
            case .list: manager.listTodos()
            case .toggle:
                guard parts.count > 1, let index = Int(parts[1]) else { print("❗ Index required"); continue }
                manager.toggleCompletion(at: index)
            case .delete:
                guard parts.count > 1, let index = Int(parts[1]) else { print("❗ Index required"); continue }
                manager.delete(at: index)
            case .exit: print("👋 Goodbye!"); return
            }
        }
    }
}

App(manager: TodosManager(cache: FileSystemCache())).run()
