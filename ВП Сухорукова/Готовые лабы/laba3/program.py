import tkinter as tk
from tkinter import messagebox, simpledialog
import networkx as nx
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg


class GraphApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Graph Path Visualization")

        self.graph = nx.Graph()
        self.create_widgets()

    def create_widgets(self):
        self.canvas = tk.Canvas(self.root, width=600, height=400)
        self.canvas.pack()

        frame = tk.Frame(self.root)
        frame.pack()

        tk.Button(frame, text="Добавить вершину", command=self.add_node).grid(row=0, column=0)
        tk.Button(frame, text="Добавить ребро", command=self.add_edge).grid(row=0, column=1)
        tk.Button(frame, text="Удалить вершину", command=self.remove_node).grid(row=0, column=2)
        tk.Button(frame, text="Удалить ребро", command=self.remove_edge).grid(row=0, column=3)
        tk.Button(frame, text="Построить граф", command=self.draw_graph).grid(row=0, column=4)
        tk.Button(frame, text="Поиск пути", command=self.find_path).grid(row=0, column=5)

    def add_node(self):
        node = simpledialog.askstring("Добавить вершину", "Введите название вершины:")
        if node:
            self.graph.add_node(node)
            self.draw_graph()

    def add_edge(self):
        node1 = simpledialog.askstring("Добавить ребро", "Введите первую вершину:")
        node2 = simpledialog.askstring("Добавить ребро", "Введите вторую вершину:")
        weight = simpledialog.askinteger("Добавить вес", "Введите вес (если не нужен, нажмите Отмена)",
                                         parent=self.root)

        if node1 and node2:
            if weight:
                self.graph.add_edge(node1, node2, weight=weight)
            else:
                self.graph.add_edge(node1, node2)
            self.draw_graph()

    def remove_node(self):
        node = simpledialog.askstring("Удалить вершину", "Введите название вершины:")
        if node in self.graph:
            self.graph.remove_node(node)
            self.draw_graph()

    def remove_edge(self):
        node1 = simpledialog.askstring("Удалить ребро", "Введите первую вершину:")
        node2 = simpledialog.askstring("Удалить ребро", "Введите вторую вершину:")
        if self.graph.has_edge(node1, node2):
            self.graph.remove_edge(node1, node2)
            self.draw_graph()

    def find_path(self):
        start = simpledialog.askstring("Поиск пути", "Введите начальную вершину:")
        end = simpledialog.askstring("Поиск пути", "Введите конечную вершину:")

        if start and end and start in self.graph and end in self.graph:
            try:
                path = nx.shortest_path(self.graph, source=start, target=end, weight='weight')
                messagebox.showinfo("Путь найден", f"Путь: {' -> '.join(path)}")
            except nx.NetworkXNoPath:
                messagebox.showerror("Ошибка", "Пути не существует")
        else:
            messagebox.showerror("Ошибка", "Некорректные вершины")

    def draw_graph(self):
        plt.clf()
        pos = nx.spring_layout(self.graph)
        labels = nx.get_edge_attributes(self.graph, 'weight')
        nx.draw(self.graph, pos, with_labels=True, node_color='lightblue', edge_color='gray')
        nx.draw_networkx_edge_labels(self.graph, pos, edge_labels=labels)

        fig = plt.gcf()
        fig.canvas.draw()

        canvas = FigureCanvasTkAgg(fig, master=self.root)
        canvas.get_tk_widget().pack()
        canvas.draw()


if __name__ == "__main__":
    root = tk.Tk()
    app = GraphApp(root)
    root.mainloop()
