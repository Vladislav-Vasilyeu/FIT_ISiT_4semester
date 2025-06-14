-- Всё, что доступно клиенту
GRANT EXECUTE ON MakeBooking TO manager_role;
GRANT EXECUTE ON ConfirmBookingPayment TO manager_role;
GRANT EXECUTE ON CancelBooking TO manager_role;
GRANT EXECUTE ON LeaveReview TO manager_role;
GRANT EXECUTE ON GetAverageTourRating TO manager_role;
GRANT EXECUTE ON GetUserBookingCount TO manager_role;

-- Дополнительные права
GRANT EXECUTE ON GetTourRevenue TO manager_role;
GRANT SELECT ON View_BookingDetails TO manager_role;
GRANT SELECT ON View_TourReviewsExtended TO manager_role;
GRANT SELECT ON View_PaymentSummary TO manager_role;
GRANT EXECUTE ON ExportToursToXML TO admin_role;




GRANT EXECUTE ON MakeBooking TO client_role;
GRANT EXECUTE ON ConfirmBookingPayment TO client_role;
GRANT EXECUTE ON CancelBooking TO client_role;
GRANT EXECUTE ON LeaveReview TO client_role;

GRANT EXECUTE ON GetAverageTourRating TO client_role;
GRANT EXECUTE ON GetUserBookingCount TO client_role;

GRANT SELECT ON View_BookingDetails TO client_role;
GRANT SELECT ON View_TourReviewsExtended TO client_role;
GRANT SELECT ON View_PaymentSummary TO client_role;



-- Можно просто:
GRANT EXECUTE ON MakeBooking TO admin_role;
GRANT EXECUTE ON ConfirmBookingPayment TO admin_role;
GRANT EXECUTE ON CancelBooking TO admin_role;
GRANT EXECUTE ON LeaveReview TO admin_role;
GRANT EXECUTE ON GetAverageTourRating TO admin_role;
GRANT EXECUTE ON GetUserBookingCount TO admin_role;
GRANT EXECUTE ON GetTourRevenue TO admin_role;
GRANT EXECUTE ON ExportToursToXML TO admin_role;

GRANT SELECT ON View_BookingDetails TO admin_role;
GRANT SELECT ON View_TourReviewsExtended TO admin_role;
GRANT SELECT ON View_PaymentSummary TO admin_role;
GRANT SELECT ON Export_XML_Log TO admin_role;


GRANT client_role TO user_client;
GRANT manager_role TO user_manager;
GRANT admin_role TO user_admin;




SELECT OBJECT_NAME, OBJECT_TYPE 
FROM USER_OBJECTS 
WHERE OBJECT_NAME IN (
  'MAKEBOOKING',
  'CONFIRMBOOKINGPAYMENT',
  'CANCELBOOKING',
  'LEAVEREVIEW',
  'GETUSERBOOKINGCOUNT',
  'GETAVERAGETOURRATING',
  'GETTOURREVENUE',
  'VIEW_BOOKINGDETAILS',
  'VIEW_TOURREVIEWSEXTENDED',
  'VIEW_PAYMENTSUMMARY'
);



-- Процедуры
GRANT EXECUTE ON MakeBooking TO client_role;
GRANT EXECUTE ON ConfirmBookingPayment TO client_role;
GRANT EXECUTE ON LeaveReview TO client_role;
GRANT EXECUTE ON CancelBooking TO client_role;

-- Функции
GRANT EXECUTE ON GetUserBookingCount TO client_role;
GRANT EXECUTE ON GetAverageTourRating TO client_role;

-- Представления
GRANT SELECT ON View_BookingDetails TO client_role;
GRANT SELECT ON View_TourReviewsExtended TO client_role;
GRANT SELECT ON View_PaymentSummary TO client_role;

GRANT CREATE SYNONYM TO client_role;
GRANT CREATE SYNONYM TO manager_role;
GRANT CREATE SYNONYM TO admin_role;

GRANT client_role TO user_client;
GRANT manager_role TO user_manager;
GRANT admin_role TO user_admin;


CREATE SYNONYM MakeBooking FOR TRAGSYS.MakeBooking;
CREATE SYNONYM ConfirmBookingPayment FOR TRAGSYS.ConfirmBookingPayment;
CREATE SYNONYM CancelBooking FOR TRAGSYS.CancelBooking;
CREATE SYNONYM LeaveReview FOR TRAGSYS.LeaveReview;
CREATE SYNONYM GetUserBookingCount FOR TRAGSYS.GetUserBookingCount;
CREATE SYNONYM GetAverageTourRating FOR TRAGSYS.GetAverageTourRating;
CREATE SYNONYM GetTourRevenue FOR TRAGSYS.GetTourRevenue;
CREATE SYNONYM GetAverageTourRating FOR TRAGSYS.GetAverageTourRating;
CREATE SYNONYM View_BookingDetails FOR TRAGSYS.View_BookingDetails;
CREATE SYNONYM View_TourReviewsExtended FOR TRAGSYS.View_TourReviewsExtended;
CREATE SYNONYM View_PaymentSummary FOR TRAGSYS.View_PaymentSummary;
CREATE SYNONYM EXPORTTOURSTOXML FOR TRAGSYS.EXPORTTOURSTOXML;



CREATE OR REPLACE TRIGGER trg_UpdateTourRating
AFTER INSERT ON TourReviews
DECLARE
BEGIN
  FOR r IN (
    SELECT TourId FROM TourReviews
    GROUP BY TourId
  ) LOOP
    UPDATE Tours
    SET Rating = (
      SELECT ROUND(AVG(Rating))
      FROM TourReviews
      WHERE TourId = r.TourId
    )
    WHERE TourId = r.TourId;
  END LOOP;
END;
/


-- Подключись под TRAGSYS:
GRANT SELECT ON Tours TO manager_role;
GRANT SELECT ON Bookings TO manager_role;
GRANT SELECT ON Payments TO manager_role;

-- Подключись под USER_MANAGER и создай синонимы:
CREATE SYNONYM Tours FOR TRAGSYS.Tours;
CREATE SYNONYM Bookings FOR TRAGSYS.Bookings;
CREATE SYNONYM Payments FOR TRAGSYS.Payments;
CREATE SYNONYM View_TourReviewsExtended FOR TRAGSYS.View_TourReviewsExtended;
SELECT TRAGSYS.GetTourRevenue(30) FROM dual;

