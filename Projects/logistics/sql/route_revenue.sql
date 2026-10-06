WITH fuel_costs AS (
	SELECT
		t.trip_id,
		t.load_id,
		total_cost AS fuel_cost
	FROM trips t
	LEFT JOIN fuel_purchases fp
	ON t.trip_id = fp.trip_id
	WHERE fp.total_cost IS NOT NULL
	ORDER BY t.load_id
)

SELECT
	route_id,
	ROUND(SUM(revenue) + SUM(fuel_surcharge) - SUM(fuel_cost),2) AS net_revenue
FROM loads l
LEFT JOIN fuel_costs fc
ON l.load_id = fc.load_id
GROUP BY route_id
ORDER BY net_revenue ASC;