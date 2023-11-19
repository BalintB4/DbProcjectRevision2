-- Check if Orthology is really unique even if gene1 and gene2 changes
SELECT * FROM ORTHOLOGY o1
    INNER JOIN ORTHOLOGY o2 ON o1.gene1_id = o2.gene2_id AND o1.gene2_id = o2.gene1_id;
 
SELECT * FROM ORTHOLOGY
WHERE GENE1_ID = GENE2_ID;

-- Check if Orthology is really unique even if gene1 and gene2 changes
SELECT * FROM SYNTHETICLETHALITY s1
    INNER JOIN SYNTHETICLETHALITY s2 ON s1.gene1_id = s2.gene2_id AND s1.gene2_id = s2.gene1_id;
    
SELECT * FROM SYNTHETICLETHALITY
WHERE GENE1_ID = GENE2_ID;

-- print human genes that we have (production)
SELECT GENE_ID FROM GENE
WHERE GENE_TYPE_ID IN (SELECT GENE_TYPE_ID FROM GENETYPELOOKUP WHERE GENE_TYPE = 'Human');

-- get potential of human gene being synthetic lethal
SELECT * FROM (
    SELECT GENE1_ID, GENE2_id 
    FROM ORTHOLOGY
    UNION ALL
    SELECT GENE2_ID, GENE1_id 
    FROM ORTHOLOGY
    ) newO -- map the two rows of the table into one so we don't have to work with tons of 'OR'-statements
INNER JOIN GENE g2 -- the orthology gene (not human)
    ON newO.GENE2_ID = g2.GENE_ID
    --AND g2.GENE_TYPE_ID = 1 -- special type selection possible
INNER JOIN (
    SELECT GENE1_ID, GENE2_id, SCORE 
    FROM SYNTHETICLETHALITY
    UNION ALL
    SELECT GENE2_ID, GENE1_id, SCORE
    FROM SYNTHETICLETHALITY
    ) newS -- same as with the orthology table
    ON newS.GENE1_ID = g2.GENE_ID
INNER JOIN GENE co_die_gene -- all the not human genes that are synthetic lethal
    ON newS.GENE2_ID = co_die_gene.GENE_ID
    AND g2.GENE_TYPE_ID = co_die_gene.GENE_TYPE_ID 
    -- same species as gene2! a gene from a type should just be synthetic
    -- lethal with another of the same type! (just safety a measure)
INNER JOIN (
    SELECT GENE1_ID, GENE2_id 
    FROM ORTHOLOGY
    UNION ALL
    SELECT GENE2_ID, GENE1_id 
    FROM ORTHOLOGY
    ) newO2
    ON newO2.GENE1_ID = co_die_gene.GENE_ID -- gene1 is not human and gene2 is human
INNER JOIN GENE g3
    ON g3.GENE_ID = newO2.GENE2_ID -- check if gene2 are all human (safety)
WHERE newO.GENE1_ID = '545'; -- select gene to look at.


-- get potential of human gene being synthetic lethal (final for customer)
SELECT newO2.GENE2_ID, newS.Score, CASE WHEN newO2.GENE2_ID IN (SELECT GENE_ID FROM ESSENTIALGENE) THEN 'true' ELSE 'false' END AS "isEssential" FROM (
    SELECT GENE1_ID, GENE2_id 
    FROM ORTHOLOGY
    UNION ALL
    SELECT GENE2_ID, GENE1_id 
    FROM ORTHOLOGY
    ) newO -- map the two rows of the table into one so we don't have to work with tons of 'OR'-statements
INNER JOIN GENE g2 -- the orthology gene (not human)
    ON newO.GENE2_ID = g2.GENE_ID
    --AND g2.GENE_TYPE_ID = 1 -- special type selection possible
INNER JOIN (
    SELECT GENE1_ID, GENE2_id, SCORE 
    FROM SYNTHETICLETHALITY
    UNION ALL
    SELECT GENE2_ID, GENE1_id, SCORE
    FROM SYNTHETICLETHALITY
    ) newS -- same as with the orthology table
    ON newS.GENE1_ID = g2.GENE_ID
INNER JOIN GENE co_die_gene -- all the not human genes that are synthetic lethal
    ON newS.GENE2_ID = co_die_gene.GENE_ID
    AND g2.GENE_TYPE_ID = co_die_gene.GENE_TYPE_ID 
    -- same species as gene2! a gene from a type should just be synthetic
    -- lethal with another of the same type! (just safety a measure)
INNER JOIN (
    SELECT GENE1_ID, GENE2_id 
    FROM ORTHOLOGY
    UNION ALL
    SELECT GENE2_ID, GENE1_id 
    FROM ORTHOLOGY
    ) newO2
    ON newO2.GENE1_ID = co_die_gene.GENE_ID -- gene1 is not human and gene2 is human
WHERE newO.GENE1_ID = '545'; -- select gene to look at.