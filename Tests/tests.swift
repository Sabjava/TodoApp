import XCTest
@testable import TodoApp

final class TodoTests: XCTestCase {
    func testDescriptionIncomplete() {
        XCTAssertEqual(Todo(id: UUID(), title: "Test", isCompleted: false).description, "❌ Test")
    }
    func testDescriptionComplete() {
        XCTAssertEqual(Todo(id: UUID(), title: "Done", isCompleted: true).description, "✅ Done")
    }
    func testCodable() throws {
        let todo = Todo(id: UUID(), title: "A", isCompleted: true)
        let decoded = try JSONDecoder().decode(Todo.self, from: try JSONEncoder().encode(todo))
        XCTAssertEqual(decoded.title, "A")
        XCTAssertTrue(decoded.isCompleted)
    }
}

final class InMemoryCacheTests: XCTestCase {
    func testSaveAndLoad() {
        let cache = InMemoryCache()
        XCTAssertNil(cache.load())
        XCTAssertTrue(cache.save(todos: [Todo(id: UUID(), title: "A", isCompleted: false)]))
        XCTAssertEqual(cache.load()?.count, 1)
        XCTAssertEqual(cache.load()?.first?.title, "A")
    }
}

final class FileSystemCacheTests: XCTestCase {
    private let filename = "test-todos.json"
    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
    }
    override func tearDown() { try? FileManager.default.removeItem(at: url) }
    func testLoadEmpty() {
        try? FileManager.default.removeItem(at: url)
        XCTAssertNil(FileSystemCache(filename: filename).load())
    }
    func testSaveAndLoad() {
        let cache = FileSystemCache(filename: filename)
        XCTAssertTrue(cache.save(todos: [Todo(id: UUID(), title: "B", isCompleted: true)]))
        XCTAssertEqual(cache.load()?.first?.title, "B")
        XCTAssertEqual(cache.load()?.first?.isCompleted, true)
    }
}

final class TodosManagerTests: XCTestCase {
    func testAdd() {
        let cache = InMemoryCache()
        let manager = TodosManager(cache: cache)
        manager.add("Buy milk")
        XCTAssertEqual(cache.load()?.count, 1)
        XCTAssertEqual(cache.load()?.first?.title, "Buy milk")
        XCTAssertFalse(cache.load()!.first!.isCompleted)
    }
    func testToggle() {
        let cache = InMemoryCache()
        let manager = TodosManager(cache: cache)
        manager.add("Task")
        manager.toggleCompletion(at: 0)
        XCTAssertTrue(cache.load()!.first!.isCompleted)
    }
    func testDelete() {
        let cache = InMemoryCache()
        let manager = TodosManager(cache: cache)
        manager.add("Task")
        manager.delete(at: 0)
        XCTAssertTrue(cache.load()?.isEmpty ?? false)
    }
    func testLoadsFromCache() {
        let cache = InMemoryCache()
        cache.save(todos: [Todo(id: UUID(), title: "Saved", isCompleted: false)])
        TodosManager(cache: cache).add("New")
        XCTAssertEqual(cache.load()?.count, 2)
    }
    func testInvalidToggle() {
        let cache = InMemoryCache()
        TodosManager(cache: cache).toggleCompletion(at: 0)
        XCTAssertNil(cache.load())
    }
}
