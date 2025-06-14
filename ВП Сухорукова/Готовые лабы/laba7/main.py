import pygame
import random

# --- Настройки экрана и FPS ---
WIDTH, HEIGHT = 800, 600
FPS = 60

# --- Размеры спрайтов ---
GIFT_SIZE   = (50, 50)
PLAYER_SIZE = (60, 80)
BASKET_SIZE = (80, 60)

# --- Цвета ---
WHITE = (255, 255, 255)

# --- Инициализация Pygame ---
pygame.init()
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("🎁 Сортировка подарков")
clock = pygame.time.Clock()

# --- Звуковые эффекты ---
correct_sound = pygame.mixer.Sound("assets/correct_sound.wav")
wrong_sound   = pygame.mixer.Sound("assets/wrong_sound.wav")

# --- Утилита для загрузки и масштабирования PNG с альфой ---
def load_image(path, size):
    img = pygame.image.load(path).convert_alpha()
    return pygame.transform.scale(img, size)

# --- Классы спрайтов ---
class Gift(pygame.sprite.Sprite):
    def __init__(self, color):
        super().__init__()
        self.color = color
        self.image = load_image(f"assets/gift_{color}.png", GIFT_SIZE)
        self.rect = self.image.get_rect()
        # Спавним в случайной точке по горизонтали, сверху
        self.rect.x = random.randint(0, WIDTH - self.rect.width)
        self.rect.y = -self.rect.height
        self.speed = 2  # <--  скорость падения

    def update(self):
        self.rect.y += self.speed

class Player(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = load_image("assets/player.png", PLAYER_SIZE)
        self.rect = self.image.get_rect()
        self.rect.centerx = WIDTH // 2
        # Ставим эльфа чуть выше корзин:
        self.rect.bottom = HEIGHT - BASKET_SIZE[1] - 10
        self.speed = 8
        self.carrying = None  # пойманный подарок

    def update(self, keys):
        if keys[pygame.K_LEFT] and self.rect.left > 0:
            self.rect.x -= self.speed
        if keys[pygame.K_RIGHT] and self.rect.right < WIDTH:
            self.rect.x += self.speed

    def draw(self, surface):
        surface.blit(self.image, self.rect)
        if self.carrying:
            gift_img = load_image(f"assets/gift_{self.carrying}.png", GIFT_SIZE)
            gx = self.rect.centerx - gift_img.get_width() // 2
            gy = self.rect.top - gift_img.get_height() - 5
            surface.blit(gift_img, (gx, gy))

class Basket(pygame.sprite.Sprite):
    def __init__(self, color, x_center):
        super().__init__()
        self.color = color
        self.image = load_image(f"assets/basket_{color}.png", BASKET_SIZE)
        self.rect = self.image.get_rect()
        self.rect.centerx = x_center
        self.rect.bottom = HEIGHT

    def draw(self, surface):
        surface.blit(self.image, self.rect)

# --- Создаём группы и спрайты ---
all_sprites = pygame.sprite.Group()
gifts       = pygame.sprite.Group()

player = Player()
all_sprites.add(player)

basket_colors    = ["red", "green", "blue"]
basket_positions = [WIDTH//4, WIDTH//2, 3*WIDTH//4]
baskets = [Basket(c, x) for c, x in zip(basket_colors, basket_positions)]

# --- Счёт и шрифты ---
score = 0
font       = pygame.font.SysFont(None, 36)
instr_font = pygame.font.SysFont(None, 24)
instructions = [
    "⬅️ ➡️ Двигай эльфа стрелками.",
    "🙏 Лови падающие подарки автоматически.",
    "🕹️ Нажми ПРОБЕЛ, чтобы сбросить подарок в корзину под собой.",
    "✅ Правильная корзина +1, ❌ неправильная −1.",
    "⚠️ Если промахнулся — −1."
]

# --- Таймер спавна подарков ---
GIFT_EVENT = pygame.USEREVENT + 1
pygame.time.set_timer(GIFT_EVENT, 3000)

# --- Главный цикл ---
running = True
while running:
    clock.tick(FPS)
    for ev in pygame.event.get():
        if ev.type == pygame.QUIT:
            running = False
        elif ev.type == GIFT_EVENT:
            g = Gift(random.choice(basket_colors))
            gifts.add(g)
            all_sprites.add(g)
        elif ev.type == pygame.KEYDOWN and ev.key == pygame.K_SPACE:
            if player.carrying:
                dropped = player.carrying
                for b in baskets:
                    if b.rect.left <= player.rect.centerx <= b.rect.right:
                        if b.color == dropped:
                            score += 1
                            correct_sound.play()
                        else:
                            score -= 1
                            wrong_sound.play()
                        break
                player.carrying = None

    # --- Обновления ---
    keys = pygame.key.get_pressed()
    player.update(keys)
    gifts.update()

    # --- Ловим и сортируем подарки ---
    for gift in list(gifts):
        # Если подарок пойман:
        if gift.rect.colliderect(player.rect) and player.carrying is None:
            player.carrying = gift.color
            gift.kill()
        # Если подарок упал мимо эльфа:
        elif gift.rect.top > HEIGHT:
            score -= 1
            wrong_sound.play()
            gift.kill()

    # --- Отрисовка ---
    screen.fill(WHITE)
    for b in baskets: b.draw(screen)
    for s in all_sprites:
        if not isinstance(s, Player):
            screen.blit(s.image, s.rect)
    player.draw(screen)

    # Счёт
    scr_surf = font.render(f"Счёт: {score}", True, (0,0,0))
    screen.blit(scr_surf, (10, 10))
    # Инструкции
    for i, line in enumerate(instructions):
        txt = instr_font.render(line, True, (80,80,80))
        screen.blit(txt, (10, 50 + i*20))

    pygame.display.flip()

pygame.quit()
