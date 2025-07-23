	// ExportCertificate into the specified Kubernetes Secret
    if resp.Certificate.Status != "ISSUED" {
        return &resource{ko}, nil
    }

	if err = rm.maybeExportCertificate(ctx, r); err != nil {
		rlog.Info("failed to export certificate", "error", err)
	}