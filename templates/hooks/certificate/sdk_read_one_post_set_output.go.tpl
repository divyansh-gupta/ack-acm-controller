	if resp.Certificate.Status == "PENDING_VALIDATION" {
		// Queue the resource up for immediate reconciliation
		syncCondition := &ackv1alpha1.Condition{
			Type:   ackv1alpha1.ConditionTypeResourceSynced,
			Status: corev1.ConditionFalse,
			Reason: aws.String("PENDING_VALIDATION"),
		}
		ko.Status.Conditions = append(ko.Status.Conditions, syncCondition)
	}
	if resp.Certificate.Status == "ISSUED" {
		// ExportCertificate into the specified Kubernetes Secret
		if err = rm.maybeExportCertificate(ctx, r); err != nil {
			rlog.Info("failed to export certificate", "error", err)
		}
	}