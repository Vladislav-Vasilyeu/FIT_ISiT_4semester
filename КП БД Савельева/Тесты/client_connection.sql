-- Залогинься под user_client перед запуском
-- USER: user_client / PASSWORD: client123

-- 1. Сделать бронирование
BEGIN
  MakeBooking(75, 75);
END;
/

-- 2. Подтвердить оплату (менеджер должен это делать, клиент не должен иметь доступ — проверим)
-- Должно вызвать ошибку: отсутствует EXECUTE
BEGIN
  ConfirmBookingPayment(45, 1000, 'Карта');
END;
/

-- 3. Оставить отзыв
BEGIN
  LeaveReview(75, 75, 5, 'Отличный тур, всё понравилось!');
END;
/

-- 4. Получить количество своих бронирований
SELECT GetUserBookingCount(75) FROM dual;

-- 5. Получить рейтинг тура
SELECT GetAverageTourRating(25) FROM dual;

-- 6. Попытка использования View_PaymentSummary — разрешено
SELECT * FROM View_PaymentSummary WHERE ClientName LIKE '%Пользователь%';
