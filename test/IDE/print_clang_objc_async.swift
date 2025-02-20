// RUN: %empty-directory(%t)

// RUN: %target-swift-ide-test(mock-sdk: %clang-importer-sdk) -print-module -source-filename %s -module-to-print=ObjCConcurrency -function-definitions=false -enable-experimental-concurrency > %t/ObjCConcurrency.printed.txt
// RUN: %FileCheck -input-file %t/ObjCConcurrency.printed.txt %s

// REQUIRES: objc_interop
// REQUIRES: concurrency
import _Concurrency

// CHECK-LABEL: class SlowServer : NSObject, ServiceProvider {

// CHECK: @completionHandlerAsync("doSomethingSlow(_:)", completionHandleIndex: 1)
// CHECK-NEXT: func doSomethingSlow(_ operation: String, completionHandler handler: @escaping (Int) -> Void)
// CHECK-NEXT: func doSomethingSlow(_ operation: String) async -> Int

// CHECK: @completionHandlerAsync("doSomethingDangerous(_:)", completionHandleIndex: 1)
// CHECK-NEXT: func doSomethingDangerous(_ operation: String, completionHandler handler: ((String?, Error?) -> Void)? = nil)
// CHECK-NEXT: func doSomethingDangerous(_ operation: String) async throws -> String

// CHECK: @completionHandlerAsync("checkAvailability()", completionHandleIndex: 0)
// CHECK-NEXT: func checkAvailability(completionHandler: @escaping (Bool) -> Void)
// CHECK-NEXT: func checkAvailability() async -> Bool

// CHECK: @completionHandlerAsync("anotherExample()", completionHandleIndex: 0)
// CHECK-NEXT: func anotherExample(completionBlock block: @escaping (String) -> Void)
// CHECK-NEXT: func anotherExample() async -> String

// CHECK: @completionHandlerAsync("finalExample()", completionHandleIndex: 0)
// CHECK-NEXT: func finalExampleWithReply(to block: @escaping (String) -> Void)
// CHECK-NEXT: func finalExample() async -> String

// CHECK: @completionHandlerAsync("replyingOperation(_:)", completionHandleIndex: 1)
// CHECK-NEXT: func replyingOperation(_ operation: String, replyTo block: @escaping (String) -> Void)
// CHECK-NEXT: func replyingOperation(_ operation: String) async -> String

// CHECK: @completionHandlerAsync("findAnswer()", completionHandleIndex: 0)
// CHECK-NEXT: func findAnswer(completionHandler handler: @escaping (String?, Error?) -> Void)
// CHECK-NEXT: func findAnswer() async throws -> String

// CHECK: @completionHandlerAsync("findAnswerFailingly()", completionHandleIndex: 0)
// CHECK-NEXT: func findAnswerFailingly(completionHandler handler: @escaping (String?, Error?) -> Void) throws
// CHECK-NEXT: func findAnswerFailingly() async throws -> String

// CHECK: @completionHandlerAsync("findQAndA()", completionHandleIndex: 0)
// CHECK-NEXT: func findQAndA(completionHandler handler: @escaping (String?, String?, Error?) -> Void)
// CHECK-NEXT: func findQAndA() async throws -> (String?, String)

// CHECK: @completionHandlerAsync("findQuestionableAnswers()", completionHandleIndex: 0)
// CHECK-NEXT: func findQuestionableAnswers(completionHandler handler: @escaping CompletionHandler)
// CHECK-NEXT: func findQuestionableAnswers() async throws -> (String, String?)

// CHECK: @completionHandlerAsync("doSomethingFun(_:)", completionHandleIndex: 1)
// CHECK-NEXT: func doSomethingFun(_ operation: String, then completionHandler: @escaping () -> Void)
// CHECK-NEXT: func doSomethingFun(_ operation: String) async

// CHECK: @completionHandlerAsync("doSomethingConflicted(_:)", completionHandleIndex: 1)
// CHECK-NEXT: func doSomethingConflicted(_ operation: String, completionHandler handler: @escaping (Int) -> Void)
// CHECK-NEXT: func doSomethingConflicted(_ operation: String) async -> Int
// CHECK-NEXT: func doSomethingConflicted(_ operation: String) -> Int

// CHECK: func dance(_ step: String) async -> String
// CHECK: func __leap(_ height: Int) async -> String

// CHECK: @completionHandlerAsync("runOnMainThread()", completionHandleIndex: 0)
// CHECK-NEXT: func runOnMainThread(completionHandler completion: (@MainActor (String) -> Void)? = nil)
// CHECK-NEXT: func runOnMainThread() async -> String

// CHECK: @completionHandlerAsync("asyncImportSame(_:)", completionHandleIndex: 1)
// CHECK-NEXT: func asyncImportSame(_ operation: String, completionHandler handler: @escaping (Int) -> Void)
// CHECK-NEXT: func asyncImportSame(_ operation: String) async -> Int
// CHECK-NEXT: func asyncImportSame(_ operation: String, replyTo handler: @escaping (Int) -> Void)
// CHECK-NOT: func asyncImportSame(_ operation: String) async -> Int

// CHECK: {{^[}]$}}

// CHECK-LABEL: protocol RefrigeratorDelegate
// CHECK-NEXT: func someoneDidOpenRefrigerator(_ fridge: Any)
// CHECK-NEXT: func refrigerator(_ fridge: Any, didGetFilledWithItems items: [Any])
// CHECK-NEXT: {{^}}  func refrigerator(_ fridge: Any, didGetFilledWithIntegers items: UnsafeMutablePointer<Int>, count: Int)
// CHECK-NEXT: {{^}}  func refrigerator(_ fridge: Any, willAddItem item: Any)
// CHECK-NEXT: {{^}}  func refrigerator(_ fridge: Any, didRemoveItem item: Any) -> Bool
// CHECK-NEXT: {{^[}]$}}

// CHECK-LABEL: protocol ProtocolWithSwiftAttributes {
// CHECK-NEXT: @actorIndependent func independentMethod()
// CHECK-NEXT: func asyncHandlerMethod()
// CHECK-NEXT: {{^}}  @MainActor func mainActorMethod()
// CHECK-NEXT: {{^}}  @MainActor func uiActorMethod()
// CHECK-NEXT: {{^}}  optional func missingAtAttributeMethod()
// CHECK-NEXT: {{^[}]$}}

// CHECK: {{^}}var MAGIC_NUMBER: Int32 { get }

// CHECK: func doSomethingConcurrently(_ block: @Sendable () -> Void)
