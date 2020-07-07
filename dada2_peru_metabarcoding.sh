# We need v. 3.6.1 for dada2, so to install: 
/programs//R-3.6.1/bin/R
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager") 
BiocManager::install("dada2", version = “3.9”)

# Run R code from dada2_12s_Peru_6Apr20.R:
library(dada2)

path <- "." # Path containing the fastq files (/workdir/kja68/)

# Forward and reverse fastq filenames have format: SAMPLENAME_R1_FASTQ.fastq.gz and SAMPLENAME_R2_FASTQ.fastq.gz
fnFs <- sort(list.files(path, pattern="R1_TrimmedHS", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="R2_TrimmedHS", full.names = TRUE))

# Extract sample names, assuming filenames have format: SAMPLENAME_RX.fastq.gz
sample.names <- sapply(strsplit(basename(fnFs), "_R"), `[`, 1)

# Inspect read quality profiles (~15 min.)
pdf("QualityProfile.pdf")
plotQualityProfile(fnFs, n=100)
plotQualityProfile(fnRs, n=100)
dev.off()

# Place filtered files in filtered/ subdirectory
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names
names(filtRs) <- sample.names

## truncLen and trimLeft = c(21,27) (~30 min)
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(140,140), trimLeft = c(21,27),
                     maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
                     compress=TRUE, multithread=TRUE, matchIDs=TRUE)
head(out)

errF <- learnErrors(filtFs, multithread=TRUE) # ~ 1 h for both
errR <- learnErrors(filtRs, multithread=TRUE)

pdf("Error_plot.pdf")
plotErrors(errF, nominalQ=TRUE)
dev.off()

dadaFs <- dada(filtFs, err=errF, multithread=TRUE) # ~ 3 hours
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)

mergers_20_1 <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, minOverlap=20, maxMismatch=1, verbose=TRUE) # ~ 45 min.

#Construct ASV table 
seqtab <- makeSequenceTable(mergers_20_1)
dim(seqtab)

# Inspect distribution of sequence lengths (ASV table)
table(nchar(getSequences(seqtab)))
write.csv(table(nchar(getSequences(seqtab))), "Sequence_lengths.csv")

# remove chimeras 
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE) # ~10 hours
sum(seqtab.nochim)/sum(seqtab)
dim(seqtab.nochim)

# Save the tables and workspace
write.csv(t(seqtab), "seqtab.csv")
write.csv(t(seqtab.nochim), "seqtab.nochim.csv")
save.image(file='Dada2.RData')

# Save fasta files
uniquesToFasta(getUniques(seqtab), fout="uniqueSeqs.fasta", ids=paste0("Seq", seq(length(getUniques(seqtab)))))
uniquesToFasta(getUniques(seqtab.nochim), fout="uniqueSeqs.nochim.fasta", ids=paste0("Seq", seq(length(getUniques(seqtab.nochim)))))
head(out)

mergers <- mergers_20_1

#### Track reads through the pipeline ####
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names
head(track)

colSums(track)

pdf("Track_reads.pdf")
barplot(colSums(track))
dev.off()
