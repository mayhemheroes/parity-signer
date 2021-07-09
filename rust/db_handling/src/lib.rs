pub mod metadata;
use metadata::load_metadata;

pub mod chainspecs;
use chainspecs::{load_chainspecs, Verifier};

pub mod identities;

pub mod settings;
use settings::{load_types, set_types_verifier};

mod db_utils;
pub mod constants;
mod default_type_defs;

/// struct to store three important databases: chain_spec, metadata, and types_info
pub struct DataFiles<'a> {
    pub metadata_contents: &'a str,
}

pub fn fill_database_from_files (dbname: &str, datafiles: DataFiles) -> Result<(), Box<dyn std::error::Error>> {
    let type_defs = default_type_defs::get_default_type_def();
    let types_verifier = Verifier::None;

    load_metadata(dbname, datafiles.metadata_contents)?;
    load_chainspecs(dbname)?;
    load_types(dbname, &type_defs)?;
    set_types_verifier(dbname, types_verifier)?;
    
    Ok(())
    
}

#[cfg(tests)]
mod tests {
    use super::*;
}