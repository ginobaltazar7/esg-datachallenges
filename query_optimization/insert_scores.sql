WITH sp500_esg_scores_values AS (
	with sp500_mapped as
	(
		select 
			id_map.id as id,
			sp500.instr_id as instr_id,
			id_map.name as name
		from sp500
		join id_map 
		on sp500.instr_id = id_map.instr_id
		order by sp500.instr_id asc
	)
	select 
		sp500_mapped.id as id,
		sp500_mapped.name as name,
		esg_scores.total_score as total_score,
		esg_scores.e_score as e_score,
		esg_scores.s_score as s_score,
		esg_scores.g_score as g_score,
		PERCENT_RANK() OVER(ORDER BY esg_scores.total_score DESC) as rank
	from sp500_mapped
	LEFT JOIN esg_scores
	ON sp500_mapped.id = esg_scores.id 
	ORDER BY rank asc
)

INSERT into sp500_esg_scores(id, name, total_score, e_score, s_score, g_score, rank) 
SELECT id, name, total_score, e_score, s_score, g_score, rank from sp500_esg_scores_values