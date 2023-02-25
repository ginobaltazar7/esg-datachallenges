with sp500_esg_scores_medians as 
(
	with sp500_with_scores as ( 
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
			PERCENT_RANK() OVER(ORDER BY esg_scores.total_score DESC) as total_score_percentile_rank
		from sp500_mapped
		LEFT JOIN esg_scores
		ON sp500_mapped.id = esg_scores.id 
		ORDER BY total_score_percentile_rank asc
	),
	total_score_median as (
		select 
			1 as idx,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_score) AS median_total_score
		from sp500_with_scores
	),
	e_score_median as (
		select 
			1 as idx,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY e_score) AS median_e_score
		from sp500_with_scores
	),
	s_score_median as (
		select 
			1 as idx,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s_score) AS median_s_score
		from sp500_with_scores
	),
	g_score_median as (
		select 
			1 as idx,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY g_score) AS median_g_score
		from sp500_with_scores
	)
	select 
		9999 as id,
		'**** MEDIAN ****' as name,
		total_score_median.median_total_score as total_score, 
		e_score_median.median_e_score as e_score,
		s_score_median.median_s_score as s_score,
		g_score_median.median_g_score as g_score,
		0.5000000000000001 as rank
	from total_score_median
	join e_score_median
	on total_score_median.idx = e_score_median.idx
	join s_score_median
	on total_score_median.idx = s_score_median.idx
	join g_score_median
	on total_score_median.idx = g_score_median.idx
)

--select * from sp500_esg_scores_medians
INSERT into sp500_esg_scores(id, name, total_score, e_score, s_score, g_score, rank) 
SELECT id, name, total_score, e_score, s_score, g_score, rank from sp500_esg_scores_medians
