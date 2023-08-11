import sys
import threading
import asyncio
import websockets
from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel, QVBoxLayout, QWidget
from PyQt5.QtCore import Qt, pyqtSignal, QObject


class DataUpdater(QObject):
    data_received = pyqtSignal(str)


async def websocket_task(data_updater):
    uri = "ws://localhost:8000/live/dollar_tehran3bze"
    async with websockets.connect(uri) as websocket:
        while True:
            data = await websocket.recv()
            # Process the received data
            print("Received:", data)
            # Emit the signal with the received data
            data_updater.data_received.emit(data)


def start_websocket_thread(data_updater):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(websocket_task(data_updater))


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("WebSocket Example")
        self.setGeometry(100, 100, 400, 200)
        layout = QVBoxLayout()

        self.label = QLabel()
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setWordWrap(True)  # Set word wrap to display text on multiple lines
        layout.addWidget(self.label)

        font = self.label.font()  # Get the current font
        font.setPointSize(25)  # Set the desired font size
        self.label.setFont(font)  # Apply the modified font

        self.setLayout(layout)
        self.show()
        layout.addWidget(self.label)

        central_widget = QWidget()
        central_widget.setLayout(layout)
        self.setCentralWidget(central_widget)

        # Create a DataUpdater instance and connect its signal to update the UI
        self.data_updater = DataUpdater()
        self.data_updater.data_received.connect(self.update_ui)

        # Start the WebSocket thread when the main window is shown
        self.websocket_thread = threading.Thread(
            target=start_websocket_thread, args=(self.data_updater,)
        )
        self.websocket_thread.start()

    def update_ui(self, data):
        # Update the UI with the received data
        self.label.setText("Received: " + data)

    def closeEvent(self, event):
        # Clean up the WebSocket thread before closing the application
        self.websocket_thread.join()
        event.accept()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
