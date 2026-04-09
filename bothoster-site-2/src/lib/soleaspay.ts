const SOLEASPAY_BASE = "https://soleaspay.com";

export interface PayinPayload {
  wallet: string;
  amount: number;
  currency: string;
  order_id: string;
  description: string;
  payer: string;
  payerEmail: string;
  service: number;
  otp?: string;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type SoleasRaw = Record<string, any>;

export const SOLEASPAY_NETWORKS = [
  { id: 2,  name: "Orange Money",  country: "Cameroun 🇨🇲"       },
  { id: 29, name: "Orange Money",  country: "Côte d'Ivoire 🇨🇮"  },
  { id: 30, name: "MTN MoMo",     country: "Côte d'Ivoire 🇨🇮"  },
  { id: 31, name: "Moov Money",   country: "Côte d'Ivoire 🇨🇮"  },
  { id: 32, name: "Wave",         country: "Côte d'Ivoire 🇨🇮"  },
  { id: 35, name: "MTN MoMo",     country: "Bénin 🇧🇯"          },
  { id: 36, name: "Moov Money",   country: "Bénin 🇧🇯"          },
  { id: 37, name: "T-Money",      country: "Togo 🇹🇬"           },
  { id: 38, name: "Moov Money",   country: "Togo 🇹🇬"           },
  { id: 52, name: "Vodacom",      country: "RDC 🇨🇩"            },
  { id: 53, name: "Airtel Money", country: "RDC 🇨🇩"            },
  { id: 54, name: "Orange Money", country: "RDC 🇨🇩"            },
  { id: 55, name: "Airtel Money", country: "Congo 🇨🇬"          },
  { id: 57, name: "Airtel Money", country: "Gabon 🇬🇦"          },
  { id: 58, name: "Airtel Money", country: "Ouganda 🇺🇬"        },
  { id: 59, name: "MTN MoMo",     country: "Ouganda 🇺🇬"        },
];

/** Extrait le statut d'une réponse SoleasPay quelle que soit la structure */
export function extractStatus(raw: SoleasRaw): string {
  const candidates = [
    raw?.data?.status,
    raw?.data?.payment_status,
    raw?.data?.transactionStatus,
    raw?.data?.transaction_status,
    raw?.data?.state,
    raw?.status,
    raw?.payment_status,
    raw?.transactionStatus,
    raw?.state,
    raw?.data?.payment?.status,
    raw?.data?.bill?.status,
    raw?.data?.order?.status,
  ];
  for (const c of candidates) {
    if (typeof c === "string" && c.trim()) return c.trim().toUpperCase();
  }
  return "";
}

/** Extrait la référence SoleasPay d'une réponse pay-in */
export function extractReference(raw: SoleasRaw): string {
  const candidates = [
    raw?.data?.reference,
    raw?.data?.pay_id,
    raw?.data?.payId,
    raw?.data?.transaction_id,
    raw?.data?.transactionId,
    raw?.data?.id,
    raw?.data?.bill?.reference,
    raw?.data?.payment?.reference,
    raw?.reference,
    raw?.pay_id,
  ];
  for (const c of candidates) {
    if (typeof c === "string" && c.trim()) return c.trim();
  }
  return "";
}

/** Retourne true si le statut correspond à un paiement réussi */
export function isSuccess(status: string): boolean {
  return [
    "SUCCESS", "SUCCESSFUL", "COMPLETED", "PAID", "APPROVED",
    "CONFIRMED", "DONE", "OK", "200", "ACCEPTED", "VALIDATED",
    "VALID", "EFFECTUE", "EFFECTUÉ", "SUCCES", "SUCCÈS",
  ].includes(status);
}

/** Retourne true si le statut correspond à un paiement échoué */
export function isFailure(status: string): boolean {
  return [
    "FAILED", "FAILURE", "CANCELLED", "CANCELED", "EXPIRED",
    "REJECTED", "REFUSED", "ERROR", "ECHEC", "ÉCHOUÉ", "ÉCHOUE",
    "ANNULE", "ANNULÉ", "EXPIRÉ",
  ].includes(status);
}

export async function initiatePayin(payload: PayinPayload): Promise<SoleasRaw> {
  const apiKey = import.meta.env.VITE_SOLEASPAY_API_KEY;
  if (!apiKey) throw new Error("Clé SoleasPay non configurée");

  const headers: Record<string, string> = {
    "Content-Type": "application/json",
    "x-api-key": apiKey,
    "operation": "2",
    "service": String(payload.service),
  };
  if (payload.otp) headers["otp"] = payload.otp;

  const res = await fetch(`${SOLEASPAY_BASE}/api/agent/bills/v3`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      wallet: payload.wallet,
      amount: payload.amount,
      currency: payload.currency,
      order_id: payload.order_id,
      description: payload.description,
      payer: payload.payer,
      payerEmail: payload.payerEmail,
      successUrl: window.location.origin + "/dashboard/credits",
      failureUrl: window.location.origin + "/dashboard/credits",
    }),
  });

  const data = await res.json().catch(() => ({}));
  console.log("[SoleasPay pay-in]", JSON.stringify(data));
  return data;
}

export async function verifyPayment(orderId: string, payId: string, serviceId: number): Promise<SoleasRaw> {
  const apiKey = import.meta.env.VITE_SOLEASPAY_API_KEY;
  if (!apiKey) throw new Error("Clé SoleasPay non configurée");

  const url = `${SOLEASPAY_BASE}/api/agent/verif-pay?orderId=${encodeURIComponent(orderId)}&payId=${encodeURIComponent(payId)}`;
  const res = await fetch(url, {
    method: "GET",
    headers: {
      "x-api-key": apiKey,
      "operation": "2",
      "service": String(serviceId),
    },
  });

  const data = await res.json().catch(() => ({}));
  console.log("[SoleasPay verify]", JSON.stringify(data));
  return data;
}
