import tkinter as tk
from tkinter import filedialog
from PIL import Image, ImageTk, ImageEnhance, ImageFilter
import cv2
import numpy as np


root = tk.Tk()
root.title("Обработка изображений")
root.geometry("900x500")

original_img = None
display_img = None

def open_image():
    global original_img, display_img

    file_path = filedialog.askopenfilename(filetypes=[("Image Files", "*.png;*.jpg;*.jpeg;*.bmp")])
    if not file_path:
        return

    original_img = Image.open(file_path)
    display_img = original_img.copy()
    show_image(display_img)


def show_image(img):
    img.thumbnail((400, 300))
    img_tk = ImageTk.PhotoImage(img)

    label_image.config(image=img_tk)
    label_image.image = img_tk

def reset_image():
    global display_img
    if original_img:
        display_img = original_img.copy()
        show_image(display_img)

def save_image():
    if display_img:
        file_path = filedialog.asksaveasfilename(defaultextension=".png", filetypes=[("PNG Files", "*.png"),
                                                                                    ("JPEG Files", "*.jpg"),
                                                                                    ("BMP Files", "*.bmp")])
        if file_path:
            display_img.save(file_path)

def rotate_image():
    global display_img
    if display_img:
        try:
            angle = int(rotation_entry.get())
            display_img = display_img.rotate(angle)
            show_image(display_img)
        except:
            print("Введите число")


def adjust_brightness(value):
    global display_img
    if display_img:
        enhancer = ImageEnhance.Brightness(original_img)
        display_img = enhancer.enhance(float(value))
        show_image(display_img)



def adjust_contrast(value):
    global display_img
    if display_img:
        enhancer = ImageEnhance.Contrast(original_img)
        display_img = enhancer.enhance(float(value))
        show_image(display_img)



def apply_blur():
    global display_img
    if display_img:
        display_img = display_img.filter(ImageFilter.GaussianBlur(radius=5))
        show_image(display_img)



def convert_to_grayscale():
    global display_img
    if display_img:
        display_img = display_img.convert("L")
        show_image(display_img)


def apply_canny():
    global display_img
    if display_img:
        # Преобразование в массив NumPy
        img_cv = np.array(display_img.convert("L"))
        edges = cv2.Canny(img_cv, 100, 200)

        # Преобразование обратно в PIL
        display_img = Image.fromarray(edges)
        show_image(display_img)


for i in range(4):
    root.grid_columnconfigure(i, weight=1)  # Все 4 столбца могут растягиваться
for i in range(7):
    root.grid_rowconfigure(i, weight=1)  # Все 7 строк могут растягиваться


btn_open = tk.Button(root, text="Open", command=open_image)
btn_reset = tk.Button(root, text="Reset", command=reset_image)
btn_save = tk.Button(root, text="Save", command=save_image)

btn_open.grid(row=0, column=0, sticky="ew", padx=5, pady=5)
btn_reset.grid(row=0, column=1, sticky="ew", padx=5, pady=5)
btn_save.grid(row=0, column=2, sticky="ew", padx=5, pady=5)


image_frame = tk.Frame(root, relief=tk.SUNKEN, borderwidth=2)
image_frame.grid(row=1, column=0, columnspan=3, rowspan=6, padx=10, pady=10, sticky="nsew")

label_image = tk.Label(image_frame, text="IMAGE", font=("Arial", 14))
label_image.pack(expand=True)


edit_label = tk.Label(root, text="Edit Image", font=("Arial", 12, "bold"))
edit_label.grid(row=0, column=3, padx=5, pady=5, sticky="w")

rotation_entry = tk.Entry(root, width=5)
rotation_entry.grid(row=1, column=3, padx=5, pady=5, sticky="w")
btn_rotate = tk.Button(root, text="Rotate", command=rotate_image)
btn_rotate.grid(row=1, column=3, padx=60, pady=5, sticky="w")

brightness_slider = tk.Scale(root, from_=0.5, to=2.0, resolution=0.1, orient="horizontal", label="Brightness", command=adjust_brightness)
brightness_slider.grid(row=2, column=3, padx=5, pady=5, sticky="ew")


contrast_slider = tk.Scale(root, from_=0.5, to=2.0, resolution=0.1, orient="horizontal", label="Contrast", command=adjust_contrast)
contrast_slider.grid(row=3, column=3, padx=5, pady=5, sticky="ew")


btn_blur = tk.Button(root, text="Blur", command=apply_blur)
btn_blur.grid(row=4, column=3, sticky="ew", padx=5, pady=5)


btn_gray = tk.Button(root, text="Grayscale", command=convert_to_grayscale)
btn_gray.grid(row=5, column=3, sticky="ew", padx=5, pady=5)


btn_canny = tk.Button(root, text="Canny Edge Detection", command=apply_canny)
btn_canny.grid(row=6, column=3, sticky="ew", padx=5, pady=5)

root.mainloop()
