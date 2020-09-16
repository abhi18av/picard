#!/usr/bin/env nextflow

/*
#==============================================
code documentation
#==============================================
*/


/*
#==============================================
PARAMS
#==============================================
*/


/*
#----------------------------------------------
flags
#----------------------------------------------
*/

params.createSequenceDictionary = false

/*
#----------------------------------------------
directories
#----------------------------------------------
*/

params.resultsDir = 'results/picard/createSequenceDictionary'


/*
#----------------------------------------------
file patterns
#----------------------------------------------
*/

params.refFasta = "NC000962_3.fasta"
params.readsFilePattern = "./*_{R1,R2}.fastq.gz"

/*
#----------------------------------------------
misc
#----------------------------------------------
*/

params.saveMode = 'copy'

/*
#----------------------------------------------
channels
#----------------------------------------------
*/

Channel.value("$workflow.launchDir/$params.refFasta")
        .set { ch_refFasta }

Channel.fromFilePairs(params.readsFilePattern)
        .set { ch_in_picard }

/*
#==============================================
picard
#==============================================
*/

process picardCreateSequenceDictionary {
    publishDir params.resultsDir, mode: params.saveMode
    container "quay.io/biocontainers/picard:2.23.4--0"

    when:
    params.createSequenceDictionary

    input:
    path refFasta from ch_refFasta

    output:
    file "*.dict" into ch_out_picardCreateSequenceDictionary


    script:
    refFastaName = refFasta.toString().split("\\.")[0]

    """
    picard CreateSequenceDictionary REFERENCE=${refFasta}  OUTPUT=${refFastaName}.dict
    """
}


/*
#==============================================
# extra
#==============================================
*/
