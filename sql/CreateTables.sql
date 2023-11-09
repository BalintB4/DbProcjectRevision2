CREATE TABLE GeneTypeLookup (
    gene_type_id varchar2(4) primary key,
    gene_type varchar2(15)
);

CREATE TABLE Gene (
    gene_id varchar2(10),
    gene_type_id varchar2(4),
    CONSTRAINT pk_gene_ids PRIMARY KEY(gene_id, gene_type_id),
    CONSTRAINT fk_gene_gene_type FOREIGN KEY(gene_type_id) REFERENCES GeneTypeLookup(gene_type_id)
);

CREATE TABLE EssentialGene (
    gene_id varchar2(10) primary key,
    CONSTRAINT fk_essential_gene_gene_id FOREIGN KEY(gene_id) REFERENCES Gene(gene_id)
);

CREATE TABLE SyntheticLethality (
    gene1_id varchar2(10),
    gene2_id varchar2(10),
    score number(3, 2),
    CONSTRAINT pk_synthetic_lethality_gene_ids PRIMARY KEY(gene1_id, gene2_id),
    CONSTRAINT fk_synthetic_lethality_gene_id1 FOREIGN KEY(gene1_id) REFERENCES Gene(gene_id),
    CONSTRAINT fk_synthetic_lethality_gene_id2 FOREIGN KEY(gene2_id) REFERENCES Gene(gene_id)
);

CREATE TABLE Orthology (
    gene1_id varchar2(10),
    gene2_id varchar2(10),
    CONSTRAINT pk_orthology_gene_ids PRIMARY KEY(gene1_id, gene2_id),
    CONSTRAINT fk_orthology_gene_id1 FOREIGN KEY(gene1_id) REFERENCES Gene(gene_id),
    CONSTRAINT fk_orthology_gene_id2 FOREIGN KEY(gene2_id) REFERENCES Gene(gene_id)
);

