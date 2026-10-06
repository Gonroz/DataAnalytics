WITH fuel_costs AS (
    SELECT
        t.load_id,
        SUM(fp.total_cost) AS fuel_cost
    FROM trips t
    LEFT JOIN fuel_purchases fp
        ON t.trip_id = fp.trip_id
    GROUP BY t.load_id
),
total_miles AS (
    SELECT
        l.route_id,
        SUM(t.actual_distance_miles)
        	AS total_miles_travelled,
        ROUND(AVG(t.actual_distance_miles),2)
        	AS avg_miles_travelled_per_trip
    FROM loads l
    LEFT JOIN trips t
        ON l.load_id = t.load_id
    GROUP BY l.route_id
),
route_net_revenue AS (
    SELECT
        l.route_id,
        ROUND(
            SUM(l.revenue)
            + SUM(l.fuel_surcharge)
            - SUM(fc.fuel_cost),
            2
        ) AS net_revenue,
        tm.total_miles_travelled,
        tm.avg_miles_travelled_per_trip
    FROM loads l
    LEFT JOIN fuel_costs fc
        ON l.load_id = fc.load_id
    LEFT JOIN total_miles tm
        ON l.route_id = tm.route_id
    GROUP BY l.route_id
)

SELECT
    route_id,
    net_revenue,
    total_miles_travelled,
    avg_miles_travelled_per_trip,
    ROUND(net_revenue / total_miles_travelled, 2) AS net_revenue_per_mile
FROM route_net_revenue
ORDER BY net_revenue_per_mile ASC;