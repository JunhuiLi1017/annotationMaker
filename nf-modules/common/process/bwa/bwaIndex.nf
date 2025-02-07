/*
 * Build genome index for BWA mapping
 */

process bwaIndex{
  label 'bwa'
  label 'highCpu'
  label 'highMem'

  input:
  path(fasta)

  output:
  path("bwa"), emit: index
  path("*.log"), emit: logs
  path("versions.txt"), emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  def args = task.ext.args ?: ''
  def prefix = task.ext.prefix ?: fasta.toString() - ~/(\.fa)?(\.fasta)?$/
  """
  mkdir -p bwa
  bwa index -p bwa/${prefix} ${fasta} > bwa.log 2>&1
  echo "Bwa-mem "\$(bwa 2>&1 | grep Version | cut -d" " -f2) &> versions.txt
  """
}
