/*
 * Correct fasta file for Kallisto
 */

process kallistoCorrectFasta {
  label 'unix'
  label 'medCpu'
  label 'lowMem'

  input:
  path(transcriptsFasta)

  output:
  path("corTranscripts.fa"), emit: fasta
  

  when:
  task.ext.when == null || task.ext.when

  script:
  """
  cat ${transcriptsFasta} | \
  awk -F  "|" '{if(\$0 ~ /^>.*/){print \$1;} else {print \$0;}}' | \
  sed 's/\\_mRNA//' | \
  grep -vE  ".*_PAR_Y.*" > \
  corTranscripts.fa
  """
}
