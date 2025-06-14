-- 1. Создание бронирования
BEGIN
  TRAGSYS.MakeBooking(p_UserId => 61, p_TourId => 21);
END;
/

-- 2. Подтверждение оплаты по только что созданному бронированию
-- Предполагается, что BookingId = (SELECT MAX(BookingId) FROM Bookings WHERE UserId = 10)
DECLARE
  v_booking_id NUMBER;
BEGIN
  SELECT MAX(BookingId) INTO v_booking_id
  FROM Bookings WHERE UserId = 61 AND TourId = 21;

  TRAGSYS.ConfirmBookingPayment(
    p_BookingId => v_booking_id,
    p_Amount    => 1500.00,
    p_Method    => 'Карта'
  );
END;
/

-- 3. Отмена бронирования
BEGIN
  TRAGSYS.CancelBooking(p_BookingId => (SELECT MAX(BookingId) FROM Bookings WHERE UserId = 61 AND TourId = 21));
END;
/

-- 4. Оставление отзыва
BEGIN
  TRAGSYS.LeaveReview(
    p_UserId  => 61,
    p_TourId  => 21,
    p_Rating  => 5,
    p_Comment => 'Все прошло отлично! Тур был организован идеально.'
  );
END;
/

-- 5. Получение среднего рейтинга тура
SELECT GetAverageTourRating(21) AS "Средний рейтинг тура №5" FROM dual;

-- 6. Получение количества бронирований пользователя
SELECT GetUserBookingCount(61) AS "Количество бронирований пользователя №61" FROM dual;

-- 7. Получение выручки по туру
SELECT GetTourRevenue(21) AS "Общая выручка по туру №21" FROM dual;

-- 8. Использование представления с деталями бронирований
SELECT * FROM View_BookingDetails WHERE ClientName LIKE '%61%';

-- 9. Использование представления с отзывами
SELECT * FROM View_TourReviewsExtended WHERE Tour = (SELECT ShortTitle FROM Tours WHERE TourId = 5);

-- 10. Проверка логов изменения статуса бронирования
SELECT * FROM BookingStatusLog WHERE BookingId = (SELECT MAX(BookingId) FROM Bookings WHERE UserId = 10 AND TourId = 5);

-- 11. Использование XML-экспорта
BEGIN
  ExportToursToXML;
END;
/

SELECT ExportDate, DBMS_LOB.SUBSTR(XmlData, 1000, 1) AS Preview
FROM Export_XML_Log
ORDER BY ExportDate DESC FETCH FIRST 1 ROWS ONLY;
