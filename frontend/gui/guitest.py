import sys
import time
from PyQt5.QtCore import QThread, QObject, pyqtSignal
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel
from queue import Queue


class UpdateThread(QThread):
    update_received = pyqtSignal(str)

    def __init__(self, update_queue, delay):
        super().__init__()
        self.update_queue = update_queue
        self.delay = delay

    def run(self):
        while True:
            if not self.update_queue.empty():
                update = self.update_queue.get()
                self.update_received.emit(update)


class MainWindow(QWidget):
    def __init__(self, update_queue):
        super().__init__()

        self.init_ui()

        self.update_thread = UpdateThread(
            update_queue, delay=1
        )  # Set delay to 1 second
        self.update_thread.update_received.connect(self.update_text)
        self.update_thread.start()

    def init_ui(self):
        self.setWindowTitle("Queue Update App")
        layout = QVBoxLayout()

        self.text_label = QLabel("Text: ")
        layout.addWidget(self.text_label)

        self.setLayout(layout)

    def update_text(self, new_text):
        self.text_label.setText(f"Text: {new_text}")


def init_gui():
    app = QApplication(sys.argv)
    update_queue = Queue()
    window = MainWindow(update_queue)
    window.show()

    return window, app, update_queue
