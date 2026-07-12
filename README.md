### Project Report: TodoApp CLI Tool

#### 1. Overview

The **TodoApp CLI** is a lightweight, Swift-based command-line interface designed for efficient task management. It utilizes a protocol-oriented architecture to handle data persistence, allowing users to switch between memory-based storage for testing and file-based storage for persistent data.

#### 2. Technical Architecture

The application is built on three main components to ensure modularity and maintainability:

* **Data Models**: The `Todo` struct implements `Codable` and `CustomStringConvertible`, providing a standardized way to represent and format tasks.
* **Persistence Layer**: The `Cache` protocol defines the contract for saving and loading data. Current implementations include `InMemoryCache` for volatile storage and `FileSystemCache` for storing tasks in a local `todos.json` file.
* **Manager & CLI Logic**: The `TodosManager` class handles business logic, including adding, listing, toggling, and deleting tasks. The `App` class serves as the entry point, processing user input via a `while` loop and mapping commands to the manager.

#### 3. Current Implementation Status

* **File Persistence**: The application is configured to save task data to `todos.json`. By using `FileManager.default.currentDirectoryPath`, the file is now targeted at the project's working directory, ensuring easier access and version control.
* **Command Set**: Supports the following operations:
* `add [title]`: Creates a new task.
* `list`: Displays all current tasks with completion status.
* `toggle [index]`: Switches the completion state of a specific task.
* `delete [index]`: Removes a task from the list.
* `exit`: Terminates the CLI session.



#### 4. Future Development

* **CI/CD Pipeline**: While currently managed locally, future iterations may integrate automated workflows.
* **Cloud Synchronization**: Potential extension of the `Cache` protocol to include cloud-based storage backends.

