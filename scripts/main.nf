include { writeMeta; runCCP2 } from './tasks.nf'

workflow {
  
  //params.metafile   = "/sharedfs01/enrico/CLL/analysis/PRJNA432966/meta.csv"
  //params.varsfile   = "/sharedfs01/enrico/CLL/analysis/PRJNA432966/vars.py"
  //params.varsfile   = "/sharedfs01/enrico/CLL/analysis/CCP2/vars.py"
  params.metafile   = "/sharedfs01/enrico/ccp2_nf/data/test_circompara/analysis/meta.csv"
  params.varsfile   = "/sharedfs01/enrico/ccp2_nf/data/test_circompara/analysis/vars.py"
  //params.genomefa   = '../data/annotation/CFLAR_HIPK3.fa'
  //params.anno       = '../data/annotation/CFLAR_HIPK3.gtf' 
  params.ccp2params = '-j2 -n'
  
  meta2split =  Channel
                .fromPath(params.metafile)
                .splitCsv(header: true, sep: ",", strip: true)
                .map { row -> tuple(row.sample, row.file, row.adapter) }
                .groupTuple( by: [0, 2] )
                //.view()
                
  varsTags   = Channel
                .fromPath(params.varsfile)
                .splitCsv(header: false, sep: "=", strip: true)
                .filter( {!(it[0] =~ "(^#.*)")} ) 
                .collect( { it[0].strip() + "=" + it[1].strip().replaceAll("#.*", "") }, flat: true)
                .view()
                
  //writeMeta( meta2split )
  
  //runCCP2( writeMeta.out.meta, params.varsfile, writeMeta.out.inputFiles, params.ccp2params )
}