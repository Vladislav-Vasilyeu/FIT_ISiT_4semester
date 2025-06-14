-- ================
-- Тест функционала администратора
-- user_admin
-- ================

-- 1. Добавление нового тура
BEGIN
  TRAGSYS.AddTour(
    p_ShortTitle => 'Тестовый тур',
    p_FullTitle => 'Полное описание',
    p_Description => 'Описание тура',
    p_Price => 1200,
    p_StartDate => SYSDATE + 5,
    p_EndDate => SYSDATE + 12,
    p_IsAvailable => 1,
    p_Discount => 15,
    p_Country => 'Греция',
    p_CategoryId => 2,
    p_Rating => 4
  );
END;
/


-- 2. Просмотр всех туров
SELECT * FROM TRAGSYS.Tours WHERE Country = 'Италия' ORDER BY TourId DESC FETCH FIRST 5 ROWS ONLY;

-- 3. Получение выручки по туру
SELECT TRAGSYS.GetTourRevenue(30) AS TourRevenue FROM dual;

-- 4. Вывод средней оценки по туру
SELECT TRAGSYS.GetAverageTourRating(30) AS AvgRating FROM dual;

-- 5. Подсчёт количества бронирований конкретного пользователя
SELECT TRAGSYS.GetUserBookingCount(75) AS UserBookings FROM dual;

-- 6. Просмотр представлений
SELECT * FROM TRAGSYS.View_BookingDetails WHERE BookingStatus = 'Confirmed' FETCH FIRST 5 ROWS ONLY;

SELECT * FROM TRAGSYS.View_PaymentSummary WHERE PaymentMethod = 'Карта' FETCH FIRST 5 ROWS ONLY;

SELECT * FROM TRAGSYS.View_TourReviewsExtended WHERE Rating >= 4 FETCH FIRST 5 ROWS ONLY;


-- 7. Импорт Excel-данных 
-- BEGIN
--   TRAGSYS.ImportUsersFromExcel;
-- END;
-- /

-- 8. Экспорт в XML
BEGIN
  TRAGSYS.ExportToursToXML;
END;
/

-- 9. Проверка логирования статуса бронирования
DECLARE
  v_booking_id NUMBER;
BEGIN
  SELECT MAX(BookingId) INTO v_booking_id
  FROM TRAGSYS.Bookings
  WHERE UserId = 75;

  -- Меняем статус
  UPDATE TRAGSYS.Bookings
  SET Status = 'Completed'
  WHERE BookingId = v_booking_id;
END;
/

-- Проверка лога:
SELECT * FROM TRAGSYS.BookingStatusLog WHERE BookingId = (
  SELECT MAX(BookingId) FROM TRAGSYS.Bookings WHERE UserId = 75
) ORDER BY ChangedAt DESC;

-- Конец теста
