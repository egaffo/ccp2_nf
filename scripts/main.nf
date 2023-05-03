include { writeMeta; readVars; runCCP2 } from './tasks.nf'

workflow {
  
  //params.metafile   = "/sharedfs01/enrico/CLL/analysis/PRJNA432966/meta.csv"
  //params.varsfile   = "/sharedfs01/enrico/CLL/analysis/PRJNA432966/vars.py"
  //params.varsfile   = "/sharedfs01/enrico/CLL/analysis/CCP2/vars.py"
  params.metafile   = "/sharedfs01/enrico/ccp2_nf/data/test_circompara/analysis/meta.csv"
  params.varsfile   = "/sharedfs01/enrico/ccp2_nf/data/test_circompara/analysis/vars.py"
  params.ccp2params = '-j2'
  
  meta2split =  Channel
                .fromPath(params.metafile)
                .splitCsv(header: true, sep: ",", strip: true)
                .map { row -> tuple(row.sample, row.file, row.adapter) }
                .groupTuple( by: [0, 2] )
  
  writeMeta( meta2split )
  readVars( params.varsfile )
  
  runCCP2( writeMeta.out.meta
           .combine( readVars.out.vars ), 
           writeMeta.out.sample_id,
           params.ccp2params 
          )
  
}
