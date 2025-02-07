/*
 * Build indexes for STAR alignment
 */

process starIndex {
  label (params.starLabel ?: 'star')
  label 'highCpu'
  label 'extraMem'

  input:
  path(fasta)
  path(chrSize)
  path(gtf)

  output:
  path("STAR*"), emit: index 
  path ("versions.txt"), emit: versions

  when:
  task.ext.when == null || task.ext.when

  script:
  def args = task.ext.args ?: ''
  def gtfOpts = gtf.size() > 0 ? "--sjdbGTFfile ${gtf}" : ""
  """
  echo "STAR "\$(STAR --version 2>&1) > versions.txt
  version=\$(STAR --version | cut -d_ -f2)
  mkdir -p STAR_\${version}
  chrBinNbits=\$(awk -F"\t" '{s+=\$2;l+=1}END{p=log(s/l)/log(2); printf("%.0f", (p<18 ? p:18))}' ${chrSize})
  STAR \\
    --runMode genomeGenerate \\
    ${args} ${gtfOpts} \\
    --limitGenomeGenerateRAM 33524399488 \\
    --genomeChrBinNbits \${chrBinNbits} \\
    --runThreadN ${task.cpus} \\
    --genomeDir STAR_\${version} \\
    --genomeFastaFiles $fasta
  """
}
