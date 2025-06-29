DROP PROCEDURE IF EXISTS GetDashboardOverview;
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDashboardOverview`(
    IN filter_type VARCHAR(10),
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    DECLARE filter_start DATE;
    DECLARE filter_end DATE;

    -- Set the date range based on filter type
    IF filter_type = 'today' THEN
        SET filter_start = CURDATE();
        SET filter_end = CURDATE();
    ELSEIF filter_type = 'week' THEN
        SET filter_start = DATE_SUB(CURDATE(), INTERVAL 7 DAY);
        SET filter_end = CURDATE();
    ELSEIF filter_type = 'month' THEN
        SET filter_start = DATE_SUB(CURDATE(), INTERVAL 30 DAY);
        SET filter_end = CURDATE();
    ELSEIF filter_type = 'custom' AND start_date IS NOT NULL AND end_date IS NOT NULL THEN
        SET filter_start = start_date;
        SET filter_end = end_date;
    ELSE
        SET filter_start = NULL;
        SET filter_end = NULL;
    END IF;

    -- Return dashboard JSON summary
    SELECT JSON_OBJECT(
        'metrics', JSON_OBJECT(
            'total_users', (SELECT COUNT(*) FROM users),
            'total_customers', (SELECT COUNT(*) FROM customer),
            'total_orders', (
                SELECT COUNT(*)
                FROM orders
                WHERE (filter_start IS NULL OR created_at BETWEEN filter_start AND filter_end)
            ),
            'total_bills', (
                SELECT COUNT(*)
                FROM billing
                WHERE (filter_start IS NULL OR created_at BETWEEN filter_start AND filter_end)
            ),
            'total_sales', COALESCE((
                SELECT SUM(total_price)
                FROM billing
                WHERE (filter_start IS NULL OR created_at BETWEEN filter_start AND filter_end)
            ), 0)
        ),
        'users', (
            SELECT JSON_ARRAYAGG(user_stats)
            FROM (
                SELECT JSON_OBJECT(
                    'user_id', u.employeeid,
                    'user_name', u.employee_full_name,
                    'total_orders', COUNT(DISTINCT o.order_id),
                    'total_sales', COALESCE(SUM(b.total_price), 0)
                ) AS user_stats
                FROM users u
                LEFT JOIN orders o
                    ON o.created_by = u.employeeid
                    AND (filter_start IS NULL OR o.created_at BETWEEN filter_start AND filter_end)
                LEFT JOIN billing b
                    ON b.order_id = o.order_id
                    AND (filter_start IS NULL OR b.created_at BETWEEN filter_start AND filter_end)
                GROUP BY u.employeeid, u.employee_full_name
            ) AS user_json
        ),
        'customers', (
            SELECT JSON_ARRAYAGG(customer_stats)
            FROM (
                SELECT JSON_OBJECT(
                    'customer_id', c.customer_id,
                    'store_name', c.store_name,
                    'total_orders', COUNT(DISTINCT o.order_id),
                    'total_sales', COALESCE(SUM(b.total_price), 0)
                ) AS customer_stats
                FROM customer c
                LEFT JOIN orders o
                    ON o.receiver_id = c.customer_id
                    AND (filter_start IS NULL OR o.created_at BETWEEN filter_start AND filter_end)
                LEFT JOIN billing b
                    ON b.order_id = o.order_id
                    AND (filter_start IS NULL OR b.created_at BETWEEN filter_start AND filter_end)
                GROUP BY c.customer_id, c.store_name
            ) AS customer_json
        ),
        'message', 'Dashboard data retrieved successfully'
    ) AS dashboard_summary;
END$$

DELIMITER ;
